"""
Django settings for joeshop project.

For more information on this file, see
https://docs.djangoproject.com/en/1.7/topics/settings/

For the full list of settings and their values, see
https://docs.djangoproject.com/en/1.7/ref/settings/
"""

# Build paths inside the project like this: os.path.join(BASE_DIR, ...)
import os
from decimal import Decimal
from django.contrib.messages import constants as messages
from django.utils.translation import ugettext_lazy as _

BASE_DIR = os.path.dirname(os.path.dirname(__file__))

SITE_NAME = 'vitamineral.info'
EMAIL_FROM = 'do-not-reply@vitamineral.info'
EMAIL_ADMIN = 'vitamineral1@gmail.com'
# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/1.7/howto/deployment/checklist/

# SECURITY WARNING: don't run with debug turned on in production!


ALLOWED_HOSTS = ['vitamineral.info', 'www.vitamineral.info', '127.0.0.1', '178.62.240.190']
PREPEND_WWW = False

# PAYPAL
PAYPAL_TEST = False
PAYPAL_VERSION = 93
PAYPAL_RECEIVER_EMAIL = ''

# Application definition
INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'widget_tweaks',
    'crispy_forms',
    'polymorphic',          # We need polymorphic installed for the shop
    'shop',                 # The django SHOP application
    # 'shop.addressmodel',    # The default Address and country models
    'vitashop',
    'web',
    'social.apps.django_app.default',
)

MIDDLEWARE_CLASSES = (
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.locale.LocaleMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.auth.middleware.SessionAuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'vitashop.middleware.localization.LanguageMiddleware'
)

ROOT_URLCONF = 'joeshop.urls'
WSGI_APPLICATION = 'joeshop.wsgi.application'

BTC_PRICE_TOLERANCE = Decimal('0.0002')

IS_PRODUCTION = os.environ.get('PRODUCTION')

if IS_PRODUCTION:
    # production
    DEBUG = False
    TEMPLATE_DEBUG = False

    # SECURITY WARNING: keep the secret key used in production secret!
    SECRET_KEY = os.environ.get('SECRET_KEY')

    # PAYPAL production
    PAYPAL_USERNAME = os.environ.get('PAYPAL_USERNAME'),
    PAYPAL_PASSWORD = os.environ.get('PAYPAL_PASSWORD'),
    PAYPAL_SIGNATURE = os.environ.get('PAYPAL_SIGNATURE'),
    PAYPAL_SIG_URL = 'https://api-3t.paypal.com/nvp'
    PAYPAL_CERT_URL = 'https://api.paypal.com/nvp'
    PAYPAL_REDIRECT = 'https://www.paypal.com/cgi-bin/webscr?cmd=_express-checkout&useraction=commit&token=%s'

    EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
    DATABASES = {
            'default': {
                'ENGINE': 'django.db.backends.postgresql_psycopg2',
                'NAME': os.environ.get('DB_NAME'),
                'USER': os.environ.get('DB_USER'),
                'PASSWORD': os.environ.get('DB_PASSWORD'),
                'HOST': '127.0.0.1',
                'PORT': '',
            },
        }

    # Bitcoin's bip0032 HD account
    XPUB = os.environ.get('XPUB')

    SOCIAL_AUTH_FACEBOOK_KEY = os.environ.get('FACEBOOK_KEY')
    SOCIAL_AUTH_FACEBOOK_SECRET = os.environ.get('FACEBOOK_SECRET')
    SOCIAL_AUTH_FACEBOOK_SCOPE = ['email']

    SOCIAL_AUTH_GOOGLE_PLUS_KEY = os.environ.get('GOOGLE_PLUS_KEY')
    SOCIAL_AUTH_GOOGLE_PLUS_SECRET = os.environ.get('GOOGLE_PLUS_SECRET')

    SOCIAL_AUTH_TWITTER_KEY = ''
    SOCIAL_AUTH_TWITTER_SECRET = ''

else:
    # testing
    DEBUG = True
    TEMPLATE_DEBUG = True
    SECRET_KEY = 'gfnbmsasf51x_-z8zvg12e3ofd*m$ngdrs1r1115$sw^+$k6(p'
    SITE_NAME = 'vitamineral:8080'

    # PAYPAL testing
    PAYPAL_USERNAME = 'sdk-three_api1.sdk.com'
    PAYPAL_PASSWORD = 'QFZCWN5HZM8VBG7Q'
    PAYPAL_SIGNATURE = 'A-IzJhZZjhg29XQ2qnhapuwxIDzyAZQ92FRP5dqBzVesOkzbdUONzmOU'
    PAYPAL_SIG_URL = 'https://api-3t.sandbox.paypal.com/nvp'
    PAYPAL_CERT_URL = 'https://api.sandbox.paypal.com/nvp'
    PAYPAL_REDIRECT = 'https://www.sandbox.paypal.com/cgi-bin/webscr?cmd=_express-checkout&useraction=commit&token=%s'

    # Testing env.
    EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'
    DATABASES = {
            'default': {
                'ENGINE': 'django.db.backends.postgresql_psycopg2',
                'NAME': 'vitashop',
                'USER': 'postgres',
                'PASSWORD': 'postgres',
                'HOST': '127.0.0.1',
                'PORT': '',
                'TEST_NAME': 'test_beer',
            },
        }

    # some fake Bitcoin's bip0032 HD account
    XPUB = 'xpub001MyMwAqRbcFtXgS5sYJABqqG9YLmC4Q1Rdap9gSE8NqtwybGhePY2gZ29ESFjqJoCu1Rupje8YtGqsefD265TMg7usUDFdp6W1EGMcet8'

    SOCIAL_AUTH_FACEBOOK_KEY = '111111111111111'
    SOCIAL_AUTH_FACEBOOK_SECRET = '1111111111111111111111111111111'
    SOCIAL_AUTH_FACEBOOK_SCOPE = ['email']

    SOCIAL_AUTH_GOOGLE_PLUS_KEY = '111111111111-11111111111111111111111111111111.apps.googleusercontent.com'
    SOCIAL_AUTH_GOOGLE_PLUS_SECRET = '111111111111111111111111'

    SOCIAL_AUTH_TWITTER_KEY = ''
    SOCIAL_AUTH_TWITTER_SECRET = ''




TEMPLATE_CONTEXT_PROCESSORS = (
    "django.contrib.auth.context_processors.auth",
    'django.core.context_processors.request',
    "django.core.context_processors.debug",
    "django.core.context_processors.i18n",
    "django.core.context_processors.media",
    "django.core.context_processors.static",
    "django.core.context_processors.tz",
    "django.contrib.messages.context_processors.messages",
    "social.apps.django_app.context_processors.backends",
    "social.apps.django_app.context_processors.login_redirect",
    "vitashop.context_processors.cart_obj",
    "vitashop.context_processors.currency_obj",
    "vitashop.context_processors.currency_set"
)

TEMPLATE_DIRS = (BASE_DIR + '/templates/',)

TEMPLATE_LOADERS = (
    ('django.template.loaders.cached.Loader', (
        'django.template.loaders.filesystem.Loader',
        'django.template.loaders.app_directories.Loader',
    )),
)

STATICFILES_FINDERS = (
    'django.contrib.staticfiles.finders.FileSystemFinder',
    'django.contrib.staticfiles.finders.AppDirectoriesFinder',
    'django.contrib.staticfiles.finders.DefaultStorageFinder',
)

MESSAGE_TAGS = {
    messages.ERROR: '',
    50: 'danger',
}

AUTH_USER_MODEL = 'vitashop.MyUser'
SOCIAL_AUTH_USER_MODEL = 'vitashop.MyUser'

AUTHENTICATION_BACKENDS = (
    'social.backends.facebook.FacebookOAuth2',
    'social.backends.google.GooglePlusAuth',
    #'social.backends.google.GoogleOAuth2',
    'django.contrib.auth.backends.ModelBackend',
)


LOGIN_URL = '/shop/login/'
LOGOUT_URL = '/shop/logout/'
LOGIN_REDIRECT_URL = '/'

SOCIAL_AUTH_LOGIN_REDIRECT_URL = '/shop/profile/'
SOCIAL_AUTH_LOGIN_ERROR_URL = '/shop/error/'
SOCIAL_AUTH_NEW_USER_REDIRECT_URL = '/shop/profile/'
SOCIAL_AUTH_NEW_ASSOCIATION_REDIRECT_URL = '/shop/profile/'
SOCIAL_AUTH_DISCONNECT_REDIRECT_URL = '/'

SOCIAL_AUTH_PIPELINE = (
    'social.pipeline.social_auth.social_details',
    'social.pipeline.social_auth.social_uid',
    'social.pipeline.social_auth.auth_allowed',
    'social.pipeline.social_auth.social_user',
    'social.pipeline.user.get_username',
    'social.pipeline.mail.mail_validation',
    'social.pipeline.social_auth.associate_by_email',
    'social.pipeline.user.create_user',
    'social.pipeline.social_auth.associate_user',
    'social.pipeline.social_auth.load_extra_data',
    'social.pipeline.user.user_details'
)

USE_MULTI_CURRENCY = True
PRIMARY_CURRENCY = 'CZK'
ALLOWED_CURRENCIES = ['USD', 'CZK']


CRISPY_CLASS_CONVERTERS = {'textinput': "form-control",
                           'textarea': "form-control",
                           'checkbox': "form-control",
                           'radio': "form-control",
                           'select': "form-control"}


SHOP_CART_MODIFIERS = []  # ['beershop.modifiers.MyModifier',]
SHOP_SHIPPING_BACKENDS = ['vitashop.shipping.backends.cp.CPostaShipping',
                        'vitashop.shipping.backends.personal.PersonalShipping',]

SHOP_PAYMENT_BACKENDS = ['vitashop.payment.backends.paybitcoin.BitcoinBackend',
                         'vitashop.payment.backends.paypal.PaypalBackend',]

SHOP_SHIPPING_FLAT_RATE = 0


# Internationalization
# https://docs.djangoproject.com/en/1.7/topics/i18n/

LANGUAGE_CODE = 'cs'
LANGUAGE_COOKIE_NAME = 'vitalang'
LANGUAGE_SESSION_KEY = 'vitalang'
LANGUAGES = (
  ('cs', _('Czech')),
  ('en', _('English')),
)

TIME_ZONE = 'Europe/Prague'

USE_I18N = True

USE_L10N = True

USE_TZ = True



# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/1.7/howto/static-files/

STATIC_URL = '/static/'
STATIC_ROOT = BASE_DIR + '/static/'


MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR + '/media/'

LOG_DIR = BASE_DIR + '/logs/'
LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'formatters': {
        'standard': {
            'format': '%(asctime)s [%(levelname)s] %(name)s: %(message)s'
        },
        'verbose': {
            'format': "[%(asctime)s] %(levelname)s [%(name)s, line=%(lineno)s] %(message)s",
            'datefmt': "%Y-%m-%d %H:%M:%S"
        },
    },
    'handlers': {
        'default': {
            'level': 'DEBUG',
            'class': 'logging.handlers.RotatingFileHandler',
            'filename': 'logs/mylog.log',
            'maxBytes': 1024*1024*5, # 5 MB
            'backupCount': 5,
            'formatter': 'verbose',
        },
    },
    'loggers': {
        '': {
            'handlers': ['default'],
            'level': 'DEBUG',
            'propagate': True
        },
        'vitashop.checkout': {
            'handlers': ['default'],
            'level': 'DEBUG',
            'propagate': False
        },
    }
}
