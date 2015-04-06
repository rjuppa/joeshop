from django import forms
from django.contrib.auth.forms import AuthenticationForm as DjangoAuthenticationForm, PasswordResetForm
from django.contrib.auth import get_user_model
from django.utils.translation import ugettext_lazy as _
from shop.addressmodel.models import Address, Country
from shop.forms import get_shipping_backends_choices, get_billing_backends_choices
from vitashop.models import Customer, MyUser
from django.contrib import auth


class SetPasswordForm(forms.Form):
    MIN_LENGTH = 4
    new_password1 = forms.CharField(max_length=50, widget=forms.TextInput(attrs={'placeholder': 'Set New Password'}))

    def clean_new_password1(self):
        data = self.cleaned_data['new_password1']
        if len(data) < self.MIN_LENGTH:
            raise forms.ValidationError("The new password must be at least %d characters long." %
                                        self.MIN_LENGTH)

        # At least one letter and one non-letter
        first_isalpha = data[0].isalpha()
        if all(c.isalpha() == first_isalpha for c in data):
            raise forms.ValidationError("The new password must contain at least one letter and "
                                        "at least one digit or punctuation character.")
        return data


class ValidatingPasswordChangeForm(auth.forms.PasswordChangeForm):
    MIN_LENGTH = 4
    def clean_new_password1(self):
        data = self.cleaned_data['new_password1']
        if len(data) < self.MIN_LENGTH:
            raise forms.ValidationError("The new password must be at least %d characters long." %
                                        self.MIN_LENGTH)

        # At least one letter and one non-letter
        first_isalpha = data[0].isalpha()
        if all(c.isalpha() == first_isalpha for c in data):
            raise forms.ValidationError("The new password must contain at least one letter and "
                                        "at least one digit or punctuation character.")
        return data


class RegistrationForm(forms.ModelForm):
    """
    A form that creates a user, with no privileges, from the given username and
    password.
    """
    MIN_LENGTH = 4
    error_messages = {
        'duplicate_email': _("A user with that email already exists."),
        'password_mismatch': _("The two password fields didn't match."),
    }
    email = forms.EmailField(label=_("Email"), max_length=50, help_text=_("Required. "),
        error_messages={'invalid': _("This value must be valid email address.")})
    password1 = forms.CharField(label=_("Password"),
        widget=forms.PasswordInput)
    password2 = forms.CharField(label=_("Password confirmation"),
        widget=forms.PasswordInput,
        help_text=_("Enter the same password as above, for verification."))
    language = forms.HiddenInput()

    class Meta:
        model = MyUser
        fields = ("email",)

    def clean_email(self):
        # Since User.username is unique, this check is redundant,
        # but it sets a nicer error message than the ORM.
        email = self.cleaned_data["email"]
        try:

            self.Meta.model.objects.get(email=email)
        except self.Meta.model.DoesNotExist:
            return email.lower()
        raise forms.ValidationError(
            self.error_messages['duplicate_email'],
            code='duplicate_username',
        )

    def clean_password1(self):
        data = self.cleaned_data['password1']
        if len(data) < self.MIN_LENGTH:
            raise forms.ValidationError("The new password must be at least %d characters long." %
                                        self.MIN_LENGTH)

        # At least one letter and one non-letter
        first_isalpha = data[0].isalpha()
        if all(c.isalpha() == first_isalpha for c in data):
            raise forms.ValidationError("The new password must contain at least one letter and "
                                        "at least one digit or punctuation character.")
        return data

    def clean_password2(self):
        password1 = self.cleaned_data.get("password1")
        password2 = self.cleaned_data.get("password2")
        if password1 and password2 and password1 != password2:
            raise forms.ValidationError(
                self.error_messages['password_mismatch'],
                code='password_mismatch',
            )
        return password2

    def save(self, commit=True):
        self.clean_password1()
        password = self.clean_password2()
        email = self.clean_email()
        username = email
        username = username.replace('+', '')
        username = username.replace('@', '.')
        user = self.Meta.model.objects.create_inactive_user(email, username, password)
        return user


class AuthenticationForm(DjangoAuthenticationForm):
    username = forms.CharField(max_length=254, widget=forms.TextInput(attrs={'placeholder': 'email'}))
    password = forms.CharField(label=_("Password"), widget=forms.PasswordInput(attrs={'placeholder': 'password'}))
    next = forms.HiddenInput()

    def __init__(self, request=None, *args, **kwargs):
        """
        The 'request' parameter is set for custom auth use by subclasses.
        The form data comes in via the standard 'data' kwarg.
        """
        self.request = request
        self.user_cache = None
        super(AuthenticationForm, self).__init__(*args, **kwargs)
        self.cleaned_data = {}

    def clean_username(self):
        username = self.cleaned_data.get("username")
        return username

    def clean_password(self):
        password = self.cleaned_data.get("password")
        return password

    def clean_next(self):
        next = self.cleaned_data.get("next")
        return next

class CaptchaLoginForm(AuthenticationForm):
    # captcha = CaptchaField()
    pass


class ProfileForm(forms.ModelForm):

    class Meta:
        model = MyUser
        fields = ('first_name', 'last_name')


class CustomerForm(forms.ModelForm):

    class Meta:
        model = Customer
        fields = ('language', 'currency', 'newsletter')


class ChangePasswordForm(forms.ModelForm):

    class Meta:
        model = MyUser
        fields = ('first_name', 'last_name',)


class CountryForm(forms.ModelForm):

    class Meta:
        model = Country
        fields = ('name',)

class CzechAddressForm(forms.ModelForm):

    class Meta:
        model = Address
        fields = ('name', 'address', 'city', 'zip_code', 'country')


class USAddressForm(forms.ModelForm):

    class Meta:
        model = Address
        fields = ('name', 'address', 'address2', 'city', 'zip_code', 'state', 'country')


class ShippingForm(forms.Form):
    """
    A form displaying all available payment and shipping methods (the ones
    defined in settings.SHOP_SHIPPING_BACKENDS and
    settings.SHOP_PAYMENT_BACKENDS)
    """
    shipping_method = forms.ChoiceField(choices=get_shipping_backends_choices(), label=_('Shipping method'))



class BillingForm(forms.Form):
    """
    A form displaying all available payment and shipping methods (the ones
    defined in settings.SHOP_SHIPPING_BACKENDS and
    settings.SHOP_PAYMENT_BACKENDS)
    """
    payment_method = forms.ChoiceField(choices=get_billing_backends_choices(), label=_('Payment method'))