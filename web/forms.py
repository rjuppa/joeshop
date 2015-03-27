from django import forms
from django.conf import settings


class ContactForm(forms.Form):
    name = forms.CharField(label='Name', max_length=100, required=True)
    email = forms.EmailField(label='Email', max_length=100, required=True)
    subject = forms.CharField(label='Subject', max_length=100, required=True)
    comment = forms.CharField(label='Add a comment', widget=forms.Textarea(), required=True)
    #captcha = CaptchaField()