from django.db import models
from django.conf import settings
from polymorphic.manager import PolymorphicManager
from django.utils.translation import ugettext_lazy as _
from django.template.loader import render_to_string
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser, PermissionsMixin
from django.contrib.auth import get_user_model
from shop.util.fields import CurrencyField
from shop.models.productmodel import Product
from shop.models.ordermodel import OrderPayment
from shop.addressmodel.models import Country
from shop.models.defaults.order import Order
from django.core.urlresolvers import reverse
from django.core.mail import send_mail
from django.core.mail import EmailMultiAlternatives
from django.core import validators
from django.utils import timezone
from vitashop.exchange import ExchangeService
from decimal import Decimal
import uuid
import logging

logger = logging.getLogger('vitashop')

USER_MODEL = getattr(settings, 'AUTH_USER_MODEL', 'vitashop.MyUser')

# ----------------------------------------------------- USER

class MyUserManager(BaseUserManager):
    def create_inactive_user(self, email, username, password=None):
        """
        Creates and saves a inactive User with the given email and password
        """
        user = self.create_user(email, username, password)
        user.code = self.generate_activation_key()
        user.is_active = False
        user.save(using=self._db)
        return user

    def create_user(self, email, username, password=None):
        """
        Creates and saves a User with the given email and username from social auth
        without password
        """
        if not email:
            raise ValueError('Users must have an email address')

        if not username:
            raise ValueError('Users must have an username')

        user = self.model(
            email=self.normalize_email(email),
            username=username,
        )

        user.set_password(password)
        user.is_active = True
        user.save(using=self._db)
        return user

    def generate_activation_key(self):
        import base64
        b = base64.urlsafe_b64encode(uuid.uuid4().bytes)
        s = b.decode("utf-8")
        return s

    def activate(self, code):
        try:
            user = self.model.objects.get(code=code)
            user.is_active = True
            user.code = ''
            user.save()
            return True
        except MyUser.DoesNotExist:
            return False

    def create_superuser(self, email, username, password):
        """
        Creates and saves a superuser with the given email, date of
        birth and password.
        """
        user = self.create_user(email,
            password=password,
            username=username
        )
        user.is_admin = True
        user.save(using=self._db)
        return user

class MyUser(AbstractBaseUser, PermissionsMixin):
    """
    An abstract base class implementing a fully featured User model with
    admin-compliant permissions.

    Username, password and email are required. Other fields are optional.
    """
    username = models.CharField(_('username'), max_length=30, unique=True,
        help_text=_('Required. 30 characters or fewer. Letters, digits and '
                    '@/./+/-/_ only.'),
        validators=[

            validators.RegexValidator(r'^[\w.@+-]+$', _('Enter a valid username.'), 'invalid')
        ])
    first_name = models.CharField(_('first name'), max_length=30, blank=True)
    last_name = models.CharField(_('last name'), max_length=30, blank=True)
    email = models.EmailField(_('email address'), unique=True)
    is_staff = models.BooleanField(_('staff status'), default=False,
        help_text=_('Designates whether the user can log into this admin '
                    'site.'))
    is_active = models.BooleanField(_('active'), default=True,
        help_text=_('Designates whether this user should be treated as '
                    'active. Unselect this instead of deleting accounts.'))
    is_affiliate = models.BooleanField(_('affiliate'), default=False)
    date_joined = models.DateTimeField(_('date joined'), default=timezone.now)
    code = models.CharField(_('code'), max_length=40, blank=True)
    lang = models.CharField(_('lang'), max_length=2, blank=True)
    objects = MyUserManager()

    USERNAME_FIELD = 'email'

    class Meta:
        verbose_name = _('user')
        verbose_name_plural = _('users')
        app_label = 'vitashop'
        db_table = 'vitashop_myuser'
        abstract = False
        swappable = False

    def get_full_name(self):
        """
        Returns the first_name plus the last_name, with a space in between.
        """
        full_name = '%s %s' % (self.first_name, self.last_name)
        return full_name.strip()

    def get_short_name(self):
        "Returns the short name for the user."
        return self.first_name

    def email_user(self, subject, message, from_email=None, **kwargs):
        """
        Sends an email to this User.
        """
        send_mail(subject, message, from_email, [self.email], **kwargs)

    def send_registration_mail(self):
        subject = settings.SITE_NAME + ' - Registration'
        from_email = settings.EMAIL_FROM

        content = {'site': 'http://' + settings.SITE_NAME, 'activation_code': self.code,
                   'email_to': self.email, 'lang': self.lang}
        text_content = render_to_string('mails/activation_email.txt', content)
        html_content = render_to_string('mails/activation_email.html', content)

        try:
            # send an email
            msg = EmailMultiAlternatives(subject, text_content, settings.SITE_NAME + ' <%s>' % from_email, [self.email])
            msg.attach_alternative(html_content, "text/html")
            msg.send()
        except Exception as ex:
            logger.error(ex)
            # translation.activate(cur_language)
            return False

        return True


    def __str__(self):
        return self.email



# ----------------------------------------------------- PRODUCT

class MyProductManager(PolymorphicManager):
    """A dumb manager to test the behavior with poylmorphic"""
    def get_all(self):
        return self.all()


class Category(models.Model):
    name = models.CharField(max_length=255, verbose_name=_('Name'))
    slug = models.SlugField(verbose_name=_('Slug'), unique=True)
    active = models.BooleanField(default=True, verbose_name=_('Active'))
    image = models.CharField(max_length=255, verbose_name=_('Image'), blank=True, null=True)
    intro = models.CharField(max_length=255, verbose_name=_('Intro'), blank=True, null=True)
    created = models.DateTimeField(auto_now_add=True, verbose_name=_('Created'))

    class Meta(object):
        verbose_name = _('Category')
        verbose_name_plural = _('Categories')

    def __unicode__(self):
        return self.name


class MyProduct(Product):
    currency = settings.PRIMARY_CURRENCY
    one_dollar = Decimal('0.01')

    image = models.CharField(max_length=255, verbose_name=_('Image'))
    intro = models.CharField(max_length=255, verbose_name=_('Intro'))
    link = models.CharField(max_length=255, verbose_name=_('Link'), blank=True, null=True)
    category = models.ForeignKey(Category, verbose_name=_('Category'), blank=True, null=True)
    desc1 = models.CharField(max_length=2000, verbose_name=_('Desc1'), blank=True, null=True)
    desc2 = models.CharField(max_length=2000, verbose_name=_('Desc2'), blank=True, null=True)
    desc3 = models.CharField(max_length=2000, verbose_name=_('Desc3'), blank=True, null=True)
    filter1 = models.CharField(max_length=255, verbose_name=_('Filter1'), blank=True, null=True)
    filter2 = models.CharField(max_length=255, verbose_name=_('Filter2'), blank=True, null=True)
    is_featured = models.BooleanField(default=False, verbose_name=_('Featured'))
    weight = models.DecimalField(max_digits=5, decimal_places=2, verbose_name=_('Weight'), default=0)
    old_price = models.DecimalField(max_digits=5, decimal_places=2, verbose_name=_('Old Price'), default=0)
    discount = models.DecimalField(max_digits=5, decimal_places=2, verbose_name=_('Discount'), default=0)
    ordering = models.PositiveIntegerField(_('Ordering'), blank=True, null=True)

    objects = MyProductManager()

    class Meta:
        verbose_name = _('Product')
        verbose_name_plural = _('Products')

    def set_currency(self, currency):
        self.currency = currency

    def convert_koruna_into(self, currency):
        if self.currency == settings.PRIMARY_CURRENCY:  #CZK
            return self.unit_price
        elif self.currency == 'USD':
            return self.unit_price / self.one_dollar

    def get_price(self):
        return self.unit_price

    def get_price2(self):
        if settings.USE_MULTI_CURRENCY:
            if settings.PRIMARY_CURRENCY == 'CZK':
                price = self.convert_koruna_into(self.currency)
            else:
                raise ValueError

            return price
        else:
            return self.unit_price

    def get_price_formated(self):
        price = self.get_price()
        return format(price, 3)
        # return '{1:.2f}'.format(2, price)

    def __unicode__(self):
        return self.name

    def get_absolute_url(self):
        return reverse('product_detail', kwargs={'slug': self.slug})


class Customer(models.Model):
    user = models.OneToOneField(USER_MODEL, verbose_name=_('User'))
    email = models.EmailField(max_length=255, verbose_name=_('Email'), unique=True)
    language = models.CharField(max_length=2, verbose_name=_('Language'))
    currency = models.CharField(max_length=3, verbose_name=_('Currency'))
    newsletter = models.CharField(max_length=3, verbose_name=_('Newsletter'))
    discount = models.DecimalField(max_digits=5, decimal_places=2, verbose_name=_('Discount'), default=0)
    parent = models.ForeignKey('Customer', verbose_name=_('Parent'), blank=True, null=True)

    class Meta(object):
        verbose_name = _('Customer')
        verbose_name_plural = _('Customers')
        app_label = 'vitashop'

    def __str__(self):
        return self.email

    @classmethod
    def get_customer(cls, email):
        try:
            return cls.objects.get(email=email)
        except:
            return None


class ShoppingHistory(models.Model):
    customer = models.ForeignKey(Customer, verbose_name=_('Customer'))
    product = models.ForeignKey(MyProduct, verbose_name=_('Product'))
    quantity = models.PositiveIntegerField(_('Quantity'), default=1)
    created = models.DateTimeField(auto_now_add=True, verbose_name=_('Created'))

    class Meta(object):
        verbose_name = _('ShoppingHistory')
        verbose_name_plural = _('ShoppingHistory')

    def __unicode__(self):
        return 'ShoppingHistory of %s' % self.customer.email


class PaymentHistory(OrderPayment):
    """
    A class to hold basic payment information. Backends should define their own
    more complex payment types should they need to store more informtion
    """

    CREATED = 10
    UNCONFIRMED = 20
    CONFIRMED = 30
    CANCELLED = 40

    PAYMENT_STATUSES = (
        (CREATED, _('Created')),
        (UNCONFIRMED, _('Unconfirmed')),
        (CONFIRMED, _('Confirmed')),
        (CANCELLED, _('Canceled')),
    )

    email = models.EmailField(verbose_name=_('Email'), null=True, blank=True)
    currency = models.CharField(max_length=3, verbose_name=_('Currency'))
    result = models.CharField(max_length=20, verbose_name=_('Result'))
    wallet_address = models.CharField(max_length=34, unique=True, null=True, verbose_name=_('Wallet address'))
    status = models.IntegerField(default=CREATED, choices=PAYMENT_STATUSES, verbose_name=_('Payment status'))
    created = models.DateTimeField(auto_now_add=True, verbose_name=_('Created'))

    class Meta(object):
        app_label = 'vitashop'
        verbose_name = _('Payment History')
        verbose_name_plural = _('Payment History')

    @classmethod
    def get_by_order(cls, order_id):
        try:
            return cls.objects.get(order_id=order_id)
        except:
            return None


    def __unicode__(self):
        return 'PaymentHistory of order %s' % self.order_id