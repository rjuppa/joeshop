import string
import random
import uuid
from django.db import models
from django.conf import settings
from polymorphic.manager import PolymorphicManager
from django.utils.translation import ugettext_lazy as _
from django.template.loader import render_to_string
from django.contrib.auth.models import BaseUserManager, AbstractBaseUser, PermissionsMixin
from django.contrib.auth import get_user_model
from django.core.mail import EmailMultiAlternatives, EmailMessage
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
from datetime import datetime
from vitashop.exchange import ExchangeService
from vitashop.utils import track_it
from decimal import Decimal
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
        self.send_new_user_created(email)
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

        # Order Emails

    def find_parent_customer(self, slug):
        if slug and len(slug) == 5:
            slug = slug.upper()
            cust = Customer.objects.get_by_slug(slug)
            if cust and cust.slag == slug:
                return slug
        return None

    def send_new_user_created(self, email):
        subject = 'VITAMINERAL.INFO - New User Created'
        text_content = """
        New User Created: %s
        """ % email
        try:
            send_mail(subject, text_content, 'VITAMINERAL.INFO <%s>' % settings.EMAIL_FROM,
                                         [settings.EMAIL_ADMIN])
        except Exception as ex:
            logger.error(ex)

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
        text_content = render_to_string('vitashop/mails/activation_email.txt', content)
        html_content = render_to_string('vitashop/mails/activation_email.html', content)

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

class CustomerManager(models.Manager):

    def has_user_paid_order(self, user):
        payments = PaymentHistory.objects.filter(email=user.email, status=PaymentHistory.CONFIRMED)
        if payments and len(payments) > 0:
            return True
        else:
            return False

    def get_by_email(self, email):
        try:
            customer = Customer.objects.get(email=email)
            return customer
        except Customer.DoesNotExist:
            return None

    def get_by_slug(self, slug):
        try:
            customer = Customer.objects.get(slag=slug)
            return customer
        except Customer.DoesNotExist:
            return None

    @track_it
    def normalize_email(cls, email):
        """
        Normalize the address by lowercasing
        """
        email = email or ''
        try:
            email_name, domain_part = email.strip().rsplit('@', 1)
        except ValueError:
            pass
        else:
            email = '@'.join([email_name.lower(), domain_part.lower()])
        return email

    @track_it
    def create(self, user, language, currency):
        """
        Creates and saves a new Customer
        """
        if not user:
            raise ValueError('Users must exists.')

        customer = Customer(
            user=user,
            slag=self.generate_slug(),
            email=self.normalize_email(user.email),
            language=language,
            currency=currency,
            has_newsletter=True,
            total_sale=0,
            discount=0,
            parent=None
        )
        customer.save(using=self._db)
        return customer

    def generate_slug(self):
        # slug is 6 UNIQUE random chars
        while True:
            slug = 'V' + self.generate_rnd_word(4)
            cust = self.get_by_slug(slug)
            if cust is None:
                return slug

    def generate_rnd_word(self, n):
        s = ''
        for i in range(0, n):
            s += random.choice(string.uppercase + string.digits)
        return s.upper()

class Customer(models.Model):
    user = models.OneToOneField(USER_MODEL, verbose_name=_('User'))
    slag = models.CharField(max_length=5, unique=True, null=True, verbose_name=_('Slag'))
    email = models.EmailField(max_length=255, verbose_name=_('Email'), unique=True)
    language = models.CharField(max_length=2, verbose_name=_('Language'))
    currency = models.CharField(max_length=3, verbose_name=_('Currency'))
    has_newsletter = models.BooleanField(default=True, verbose_name=_('Newsletter'))
    affiliate = models.BooleanField(default=False, verbose_name=_('Affiliate'))
    send_affiliate_email = models.DateTimeField(verbose_name=_('Affiliate_email'), null=True)
    total_sale = models.DecimalField(max_digits=11, decimal_places=4, default=0, verbose_name=_('Total Sale'))
    discount = models.DecimalField(max_digits=5, decimal_places=2, verbose_name=_('Discount'), default=0)
    parent = models.ForeignKey('Customer', verbose_name=_('Parent'), blank=True, null=True)

    objects = CustomerManager()

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
    FAILED = 90

    PAYMENT_STATUSES = (
        (CREATED, _('Created')),
        (UNCONFIRMED, _('Unconfirmed')),
        (CONFIRMED, _('Confirmed')),
        (CANCELLED, _('Canceled')),
    )

    email = models.EmailField(verbose_name=_('Email'), null=True, blank=True)
    order_price = models.DecimalField(max_digits=11, decimal_places=4, default=0, verbose_name=_('Price'))
    currency = models.CharField(max_length=3, verbose_name=_('Currency'), default='CZK')
    result = models.CharField(max_length=20, verbose_name=_('Result'), default='')
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

    # Order Emails
    def send_order_placed(self):
        subject = 'VITAMINERAL.INFO - Order placed'
        text_content = """
        An order was placed: %s
        order_total: %s
        email: %s
        payment_method: %s
        created: %s
        """ % (self.order.id, self.order.order_total, self.email, self.payment_method, self.created)
        try:
            send_mail(subject, text_content, 'VITAMINERAL.INFO <%s>' % settings.EMAIL_FROM,
                                         [settings.EMAIL_ADMIN])
        except Exception as ex:
            logger.error(ex)

    def send_unconfirmed_payment_email(self, amount):
        subject = 'VITAMINERAL.INFO - Payment Received'
        text_content = render_to_string('vitashop/mails/payment_received.txt', dict(order=self.order, amount=amount, currency=self.currency))
        html_content = render_to_string('vitashop/mails/payment_received.html', dict(order=self.order, amount=amount, currency=self.currency))
        try:
            msg = EmailMultiAlternatives(subject, text_content,
                                         'VITAMINERAL.INFO <%s>' % settings.EMAIL_FROM,
                                         [self.email])
            msg.attach_alternative(html_content, "text/html")
            msg.send()
        except Exception as ex:
            logger.error(ex)

    def send_money_received_email(self, amount):
        subject = 'VITAMINERAL.INFO - Payment Confirmed'
        text_content = render_to_string('vitashop/mails/payment_confirmed.txt', dict(order=self.order, amount=amount, currency=self.currency))
        html_content = render_to_string('vitashop/mails/payment_confirmed.html', dict(order=self.order, amount=amount, currency=self.currency))
        try:
            msg = EmailMultiAlternatives(subject, text_content,
                                         'VITAMINERAL.INFO <%s>' % settings.EMAIL_FROM,
                                         [self.email])
            msg.attach_alternative(html_content, "text/html")
            msg.send()
        except Exception as ex:
            logger.error(ex)

    def send_insufficient_payment_email(self, amount):
        subject = 'VITAMINERAL.INFO - Insufficient Payment Confirmed'
        text_content = render_to_string('vitashop/mails/insufficient_payment_received.txt', dict(order=self.order, amount=amount, order_price=self.order_price, currency=self.currency))
        html_content = render_to_string('vitashop/mails/insufficient_payment_received.html', dict(order=self.order, amount=amount, order_price=self.order_price, currency=self.currency))
        try:
            msg = EmailMultiAlternatives(subject, text_content,
                                         'VITAMINERAL.INFO <%s>' % settings.EMAIL_FROM,
                                         [self.email])
            msg.attach_alternative(html_content, "text/html")
            msg.send()
        except Exception as ex:
            logger.error(ex)

    def send_shipped_order_email(self):
        subject = 'VITAMINERAL.INFO - Order Shipped'
        text_content = render_to_string('vitashop/mails/order_shipped.txt', dict(order=self.order))
        html_content = render_to_string('vitashop/mails/order_shipped.html', dict(order=self.order))
        try:
            msg = EmailMultiAlternatives(subject, text_content,
                                         'VITAMINERAL.INFO <%s>' % settings.EMAIL_FROM,
                                         [self.email])
            msg.attach_alternative(html_content, "text/html")
            msg.send()
        except Exception as ex:
            logger.error(ex)

    def send_affiliate_email(self):
        subject = 'VITAMINERAL.INFO - Affiliate Program'
        text_content = render_to_string('vitashop/mails/affiliate_program.txt', dict(order=self.order))
        html_content = render_to_string('vitashop/mails/affiliate_program.html', dict(order=self.order))
        try:
            msg = EmailMultiAlternatives(subject, text_content,
                                         'VITAMINERAL.INFO <%s>' % settings.EMAIL_FROM,
                                         [self.email])
            msg.attach_alternative(html_content, "text/html")
            msg.send()
        except Exception as ex:
            logger.error(ex)

        self.send_affiliate_email = datetime.now()
        self.save_base(update_fields=['send_affiliate_email', ])


    def __unicode__(self):
        return 'PaymentHistory of order %s' % self.order_id