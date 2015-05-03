
-- delete all orders
DELETE FROM shop_extraorderpricefield;
DELETE FROM shop_orderextrainfo;
DELETE FROM shop_cartitem;
DELETE FROM shop_cart;
DELETE FROM vitashop_paymenthistory;
DELETE FROM vitashop_shoppinghistory;
DELETE FROM shop_orderpayment;
DELETE FROM shop_orderitem;
DELETE FROM shop_order;
DELETE FROM django_admin_log;

-- delete all users
DELETE FROM vitashop_customer;
DELETE FROM social_auth_usersocialauth;
DELETE FROM vitashop_myuser;
DELETE FROM auth_user;