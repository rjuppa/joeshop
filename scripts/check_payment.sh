#! /bin/bash
cd /home/django/github/joeshop
source /home/django/Env/joeshop/bin/activate
export SECRET_KEY="r_nbmsa%_51x_-z8zvg(-e)o(d*m---5^+(p"
# virtualenv is now active, which means your PATH has been modified.
# Don't try to run python from /usr/bin/python, just run "python" and
# let the PATH figure out which version to run (based on what your
# virtualenv has configured).

python scripts/check_payment.py


