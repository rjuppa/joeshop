--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: addressmodel_address; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE addressmodel_address (
    id integer NOT NULL,
    user_shipping_id integer,
    user_billing_id integer,
    name character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    address2 character varying(255) NOT NULL,
    zip_code character varying(20) NOT NULL,
    city character varying(20) NOT NULL,
    state character varying(255) NOT NULL,
    country_id integer
);


ALTER TABLE public.addressmodel_address OWNER TO postgres;

--
-- Name: addressmodel_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE addressmodel_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addressmodel_address_id_seq OWNER TO postgres;

--
-- Name: addressmodel_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE addressmodel_address_id_seq OWNED BY addressmodel_address.id;


--
-- Name: addressmodel_country; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE addressmodel_country (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.addressmodel_country OWNER TO postgres;

--
-- Name: addressmodel_country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE addressmodel_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.addressmodel_country_id_seq OWNER TO postgres;

--
-- Name: addressmodel_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE addressmodel_country_id_seq OWNED BY addressmodel_country.id;


--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_group (
    id integer NOT NULL,
    name character varying(80) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_id_seq OWNED BY auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_group_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_group_permissions_id_seq OWNED BY auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_permission (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_permission_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_permission_id_seq OWNED BY auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone NOT NULL,
    is_superuser boolean NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_groups_id_seq OWNED BY auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO postgres;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_id_seq OWNED BY auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE auth_user_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE auth_user_user_permissions_id_seq OWNED BY auth_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_admin_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_admin_log_id_seq OWNED BY django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_content_type (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_content_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_content_type_id_seq OWNED BY django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE django_migrations_id_seq OWNED BY django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: shop_address; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_address (
    id integer NOT NULL,
    user_shipping_id integer,
    user_billing_id integer,
    name character varying(255) NOT NULL,
    address character varying(255) NOT NULL,
    address2 character varying(255) NOT NULL,
    zip_code character varying(20) NOT NULL,
    city character varying(20) NOT NULL,
    state character varying(255) NOT NULL,
    country_id integer
);


ALTER TABLE public.shop_address OWNER TO postgres;

--
-- Name: shop_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_address_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_address_id_seq OWNER TO postgres;

--
-- Name: shop_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_address_id_seq OWNED BY shop_address.id;


--
-- Name: shop_cart; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_cart (
    id integer NOT NULL,
    user_id integer,
    date_created timestamp with time zone NOT NULL,
    last_updated timestamp with time zone NOT NULL
);


ALTER TABLE public.shop_cart OWNER TO postgres;

--
-- Name: shop_cart_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_cart_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_cart_id_seq OWNER TO postgres;

--
-- Name: shop_cart_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_cart_id_seq OWNED BY shop_cart.id;


--
-- Name: shop_cartitem; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_cartitem (
    id integer NOT NULL,
    cart_id integer NOT NULL,
    quantity integer NOT NULL,
    product_id integer NOT NULL
);


ALTER TABLE public.shop_cartitem OWNER TO postgres;

--
-- Name: shop_cartitem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_cartitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_cartitem_id_seq OWNER TO postgres;

--
-- Name: shop_cartitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_cartitem_id_seq OWNED BY shop_cartitem.id;


--
-- Name: shop_country; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_country (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.shop_country OWNER TO postgres;

--
-- Name: shop_country_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_country_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_country_id_seq OWNER TO postgres;

--
-- Name: shop_country_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_country_id_seq OWNED BY shop_country.id;


--
-- Name: shop_extraorderitempricefield; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_extraorderitempricefield (
    id integer NOT NULL,
    order_item_id integer NOT NULL,
    label character varying(255) NOT NULL,
    value numeric(30,2) NOT NULL,
    data text
);


ALTER TABLE public.shop_extraorderitempricefield OWNER TO postgres;

--
-- Name: shop_extraorderitempricefield_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_extraorderitempricefield_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_extraorderitempricefield_id_seq OWNER TO postgres;

--
-- Name: shop_extraorderitempricefield_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_extraorderitempricefield_id_seq OWNED BY shop_extraorderitempricefield.id;


--
-- Name: shop_extraorderpricefield; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_extraorderpricefield (
    id integer NOT NULL,
    order_id integer NOT NULL,
    label character varying(255) NOT NULL,
    value numeric(30,2) NOT NULL,
    data text,
    is_shipping boolean NOT NULL
);


ALTER TABLE public.shop_extraorderpricefield OWNER TO postgres;

--
-- Name: shop_extraorderpricefield_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_extraorderpricefield_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_extraorderpricefield_id_seq OWNER TO postgres;

--
-- Name: shop_extraorderpricefield_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_extraorderpricefield_id_seq OWNED BY shop_extraorderpricefield.id;


--
-- Name: shop_order; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_order (
    id integer NOT NULL,
    user_id integer,
    status integer NOT NULL,
    order_subtotal numeric(30,2) NOT NULL,
    order_total numeric(30,2) NOT NULL,
    shipping_address_text text,
    billing_address_text text,
    created timestamp with time zone NOT NULL,
    modified timestamp with time zone NOT NULL,
    cart_pk integer,
    country_id integer,
    CONSTRAINT shop_order_cart_pk_check CHECK ((cart_pk >= 0))
);


ALTER TABLE public.shop_order OWNER TO postgres;

--
-- Name: shop_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_order_id_seq OWNER TO postgres;

--
-- Name: shop_order_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_order_id_seq OWNED BY shop_order.id;


--
-- Name: shop_orderextrainfo; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_orderextrainfo (
    id integer NOT NULL,
    order_id integer NOT NULL,
    text text NOT NULL
);


ALTER TABLE public.shop_orderextrainfo OWNER TO postgres;

--
-- Name: shop_orderextrainfo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_orderextrainfo_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_orderextrainfo_id_seq OWNER TO postgres;

--
-- Name: shop_orderextrainfo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_orderextrainfo_id_seq OWNED BY shop_orderextrainfo.id;


--
-- Name: shop_orderitem; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_orderitem (
    id integer NOT NULL,
    order_id integer NOT NULL,
    product_reference character varying(255) NOT NULL,
    product_name character varying(255),
    product_id integer,
    unit_price numeric(30,2) NOT NULL,
    quantity integer NOT NULL,
    line_subtotal numeric(30,2) NOT NULL,
    line_total numeric(30,2) NOT NULL
);


ALTER TABLE public.shop_orderitem OWNER TO postgres;

--
-- Name: shop_orderitem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_orderitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_orderitem_id_seq OWNER TO postgres;

--
-- Name: shop_orderitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_orderitem_id_seq OWNED BY shop_orderitem.id;


--
-- Name: shop_orderpayment; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_orderpayment (
    id integer NOT NULL,
    order_id integer NOT NULL,
    amount numeric(30,2) NOT NULL,
    transaction_id character varying(255) NOT NULL,
    payment_method character varying(255) NOT NULL
);


ALTER TABLE public.shop_orderpayment OWNER TO postgres;

--
-- Name: shop_orderpayment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_orderpayment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_orderpayment_id_seq OWNER TO postgres;

--
-- Name: shop_orderpayment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_orderpayment_id_seq OWNED BY shop_orderpayment.id;


--
-- Name: shop_product; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE shop_product (
    id integer NOT NULL,
    polymorphic_ctype_id integer,
    name character varying(255) NOT NULL,
    slug character varying(50) NOT NULL,
    active boolean NOT NULL,
    date_added timestamp with time zone NOT NULL,
    last_modified timestamp with time zone NOT NULL,
    unit_price numeric(30,2) NOT NULL
);


ALTER TABLE public.shop_product OWNER TO postgres;

--
-- Name: shop_product_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE shop_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.shop_product_id_seq OWNER TO postgres;

--
-- Name: shop_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE shop_product_id_seq OWNED BY shop_product.id;


--
-- Name: social_auth_association; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE social_auth_association (
    id integer NOT NULL,
    server_url character varying(255) NOT NULL,
    handle character varying(255) NOT NULL,
    secret character varying(255) NOT NULL,
    issued integer NOT NULL,
    lifetime integer NOT NULL,
    assoc_type character varying(64) NOT NULL
);


ALTER TABLE public.social_auth_association OWNER TO postgres;

--
-- Name: social_auth_association_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE social_auth_association_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.social_auth_association_id_seq OWNER TO postgres;

--
-- Name: social_auth_association_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE social_auth_association_id_seq OWNED BY social_auth_association.id;


--
-- Name: social_auth_code; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE social_auth_code (
    id integer NOT NULL,
    email character varying(75) NOT NULL,
    code character varying(32) NOT NULL,
    verified boolean NOT NULL
);


ALTER TABLE public.social_auth_code OWNER TO postgres;

--
-- Name: social_auth_code_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE social_auth_code_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.social_auth_code_id_seq OWNER TO postgres;

--
-- Name: social_auth_code_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE social_auth_code_id_seq OWNED BY social_auth_code.id;


--
-- Name: social_auth_nonce; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE social_auth_nonce (
    id integer NOT NULL,
    server_url character varying(255) NOT NULL,
    "timestamp" integer NOT NULL,
    salt character varying(65) NOT NULL
);


ALTER TABLE public.social_auth_nonce OWNER TO postgres;

--
-- Name: social_auth_nonce_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE social_auth_nonce_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.social_auth_nonce_id_seq OWNER TO postgres;

--
-- Name: social_auth_nonce_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE social_auth_nonce_id_seq OWNED BY social_auth_nonce.id;


--
-- Name: social_auth_usersocialauth; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE social_auth_usersocialauth (
    id integer NOT NULL,
    provider character varying(32) NOT NULL,
    uid character varying(255) NOT NULL,
    extra_data text NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.social_auth_usersocialauth OWNER TO postgres;

--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE social_auth_usersocialauth_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.social_auth_usersocialauth_id_seq OWNER TO postgres;

--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE social_auth_usersocialauth_id_seq OWNED BY social_auth_usersocialauth.id;


--
-- Name: vitashop_category; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vitashop_category (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    slug character varying(50) NOT NULL,
    active boolean NOT NULL,
    image character varying(255),
    intro character varying(255),
    created timestamp with time zone NOT NULL
);


ALTER TABLE public.vitashop_category OWNER TO postgres;

--
-- Name: vitashop_category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE vitashop_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vitashop_category_id_seq OWNER TO postgres;

--
-- Name: vitashop_category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE vitashop_category_id_seq OWNED BY vitashop_category.id;


--
-- Name: vitashop_customer; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vitashop_customer (
    id integer NOT NULL,
    email character varying(255) NOT NULL,
    language character varying(2) NOT NULL,
    currency character varying(3) NOT NULL,
    newsletter character varying(3) NOT NULL,
    discount numeric(5,2) NOT NULL,
    parent_id integer,
    user_id integer NOT NULL
);


ALTER TABLE public.vitashop_customer OWNER TO postgres;

--
-- Name: vitashop_customer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE vitashop_customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vitashop_customer_id_seq OWNER TO postgres;

--
-- Name: vitashop_customer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE vitashop_customer_id_seq OWNED BY vitashop_customer.id;


--
-- Name: vitashop_myproduct; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vitashop_myproduct (
    product_ptr_id integer NOT NULL,
    image character varying(255) NOT NULL,
    intro character varying(255) NOT NULL,
    link character varying(255),
    desc1 character varying(2000),
    desc2 character varying(2000),
    desc3 character varying(2000),
    filter1 character varying(255),
    filter2 character varying(255),
    is_featured boolean NOT NULL,
    weight numeric(5,2) NOT NULL,
    old_price numeric(5,2) NOT NULL,
    discount numeric(5,2) NOT NULL,
    ordering integer,
    category_id integer,
    CONSTRAINT vitashop_myproduct_ordering_check CHECK ((ordering >= 0))
);


ALTER TABLE public.vitashop_myproduct OWNER TO postgres;

--
-- Name: vitashop_myuser; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vitashop_myuser (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone NOT NULL,
    is_superuser boolean NOT NULL,
    username character varying(30) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(30) NOT NULL,
    email character varying(75) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.vitashop_myuser OWNER TO postgres;

--
-- Name: vitashop_myuser_groups; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vitashop_myuser_groups (
    id integer NOT NULL,
    myuser_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.vitashop_myuser_groups OWNER TO postgres;

--
-- Name: vitashop_myuser_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE vitashop_myuser_groups_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vitashop_myuser_groups_id_seq OWNER TO postgres;

--
-- Name: vitashop_myuser_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE vitashop_myuser_groups_id_seq OWNED BY vitashop_myuser_groups.id;


--
-- Name: vitashop_myuser_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE vitashop_myuser_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vitashop_myuser_id_seq OWNER TO postgres;

--
-- Name: vitashop_myuser_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE vitashop_myuser_id_seq OWNED BY vitashop_myuser.id;


--
-- Name: vitashop_myuser_user_permissions; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vitashop_myuser_user_permissions (
    id integer NOT NULL,
    myuser_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.vitashop_myuser_user_permissions OWNER TO postgres;

--
-- Name: vitashop_myuser_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE vitashop_myuser_user_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vitashop_myuser_user_permissions_id_seq OWNER TO postgres;

--
-- Name: vitashop_myuser_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE vitashop_myuser_user_permissions_id_seq OWNED BY vitashop_myuser_user_permissions.id;


--
-- Name: vitashop_paymenthistory; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vitashop_paymenthistory (
    orderpayment_ptr_id integer NOT NULL,
    email character varying(75),
    currency character varying(3) NOT NULL,
    result character varying(20) NOT NULL,
    wallet_address character varying(34),
    status integer NOT NULL,
    created timestamp with time zone NOT NULL
);


ALTER TABLE public.vitashop_paymenthistory OWNER TO postgres;

--
-- Name: vitashop_shoppinghistory; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE vitashop_shoppinghistory (
    id integer NOT NULL,
    quantity integer NOT NULL,
    created timestamp with time zone NOT NULL,
    customer_id integer NOT NULL,
    product_id integer NOT NULL,
    CONSTRAINT vitashop_shoppinghistory_quantity_check CHECK ((quantity >= 0))
);


ALTER TABLE public.vitashop_shoppinghistory OWNER TO postgres;

--
-- Name: vitashop_shoppinghistory_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE vitashop_shoppinghistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.vitashop_shoppinghistory_id_seq OWNER TO postgres;

--
-- Name: vitashop_shoppinghistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE vitashop_shoppinghistory_id_seq OWNED BY vitashop_shoppinghistory.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY addressmodel_address ALTER COLUMN id SET DEFAULT nextval('addressmodel_address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY addressmodel_country ALTER COLUMN id SET DEFAULT nextval('addressmodel_country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group ALTER COLUMN id SET DEFAULT nextval('auth_group_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('auth_group_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission ALTER COLUMN id SET DEFAULT nextval('auth_permission_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user ALTER COLUMN id SET DEFAULT nextval('auth_user_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups ALTER COLUMN id SET DEFAULT nextval('auth_user_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('auth_user_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log ALTER COLUMN id SET DEFAULT nextval('django_admin_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_content_type ALTER COLUMN id SET DEFAULT nextval('django_content_type_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_migrations ALTER COLUMN id SET DEFAULT nextval('django_migrations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_address ALTER COLUMN id SET DEFAULT nextval('shop_address_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_cart ALTER COLUMN id SET DEFAULT nextval('shop_cart_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_cartitem ALTER COLUMN id SET DEFAULT nextval('shop_cartitem_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_country ALTER COLUMN id SET DEFAULT nextval('shop_country_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_extraorderitempricefield ALTER COLUMN id SET DEFAULT nextval('shop_extraorderitempricefield_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_extraorderpricefield ALTER COLUMN id SET DEFAULT nextval('shop_extraorderpricefield_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_order ALTER COLUMN id SET DEFAULT nextval('shop_order_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_orderextrainfo ALTER COLUMN id SET DEFAULT nextval('shop_orderextrainfo_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_orderitem ALTER COLUMN id SET DEFAULT nextval('shop_orderitem_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_orderpayment ALTER COLUMN id SET DEFAULT nextval('shop_orderpayment_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_product ALTER COLUMN id SET DEFAULT nextval('shop_product_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_auth_association ALTER COLUMN id SET DEFAULT nextval('social_auth_association_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_auth_code ALTER COLUMN id SET DEFAULT nextval('social_auth_code_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_auth_nonce ALTER COLUMN id SET DEFAULT nextval('social_auth_nonce_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_auth_usersocialauth ALTER COLUMN id SET DEFAULT nextval('social_auth_usersocialauth_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_category ALTER COLUMN id SET DEFAULT nextval('vitashop_category_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_customer ALTER COLUMN id SET DEFAULT nextval('vitashop_customer_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_myuser ALTER COLUMN id SET DEFAULT nextval('vitashop_myuser_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_myuser_groups ALTER COLUMN id SET DEFAULT nextval('vitashop_myuser_groups_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_myuser_user_permissions ALTER COLUMN id SET DEFAULT nextval('vitashop_myuser_user_permissions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_shoppinghistory ALTER COLUMN id SET DEFAULT nextval('vitashop_shoppinghistory_id_seq'::regclass);


--
-- Data for Name: addressmodel_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY addressmodel_address (id, user_shipping_id, user_billing_id, name, address, address2, zip_code, city, state, country_id) FROM stdin;
1	1	\N	radek	aaaa		432	city	st	1
2	\N	1	radek	aaaaa		432	city	st	1
\.


--
-- Name: addressmodel_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('addressmodel_address_id_seq', 2, true);


--
-- Data for Name: addressmodel_country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY addressmodel_country (id, name) FROM stdin;
1	Czech republic
2	France
3	Deutschland
\.


--
-- Name: addressmodel_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('addressmodel_country_id_seq', 1, true);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group (id, name) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_id_seq', 1, false);


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_group_permissions_id_seq', 1, false);


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can add permission	2	add_permission
5	Can change permission	2	change_permission
6	Can delete permission	2	delete_permission
7	Can add group	3	add_group
8	Can change group	3	change_group
9	Can delete group	3	delete_group
13	Can add content type	5	add_contenttype
14	Can change content type	5	change_contenttype
15	Can delete content type	5	delete_contenttype
16	Can add session	6	add_session
17	Can change session	6	change_session
18	Can delete session	6	delete_session
19	Can add Cart	7	add_cart
20	Can change Cart	7	change_cart
21	Can delete Cart	7	delete_cart
22	Can add Cart item	8	add_cartitem
23	Can change Cart item	8	change_cartitem
24	Can delete Cart item	8	delete_cartitem
25	Can add Product	9	add_product
26	Can change Product	9	change_product
27	Can delete Product	9	delete_product
28	Can add Order	10	add_order
29	Can change Order	10	change_order
30	Can delete Order	10	delete_order
31	Can add Order item	11	add_orderitem
32	Can change Order item	11	change_orderitem
33	Can delete Order item	11	delete_orderitem
34	Can add Order extra info	12	add_orderextrainfo
35	Can change Order extra info	12	change_orderextrainfo
36	Can delete Order extra info	12	delete_orderextrainfo
37	Can add Extra order price field	13	add_extraorderpricefield
38	Can change Extra order price field	13	change_extraorderpricefield
39	Can delete Extra order price field	13	delete_extraorderpricefield
40	Can add Extra order item price field	14	add_extraorderitempricefield
41	Can change Extra order item price field	14	change_extraorderitempricefield
42	Can delete Extra order item price field	14	delete_extraorderitempricefield
43	Can add Order payment	15	add_orderpayment
44	Can change Order payment	15	change_orderpayment
45	Can delete Order payment	15	delete_orderpayment
46	Can add Country	16	add_country
47	Can change Country	16	change_country
48	Can delete Country	16	delete_country
49	Can add Address	17	add_address
50	Can change Address	17	change_address
51	Can delete Address	17	delete_address
52	Can add beer	18	add_beer
53	Can change beer	18	change_beer
54	Can delete beer	18	delete_beer
55	Can add Country	19	add_country
56	Can change Country	19	change_country
57	Can delete Country	19	delete_country
58	Can add Address	20	add_address
59	Can change Address	20	change_address
60	Can delete Address	20	delete_address
61	Can add Category	21	add_category
62	Can change Category	21	change_category
63	Can delete Category	21	delete_category
64	Can add Product	22	add_myproduct
65	Can change Product	22	change_myproduct
66	Can delete Product	22	delete_myproduct
67	Can add Customer	23	add_customer
68	Can change Customer	23	change_customer
69	Can delete Customer	23	delete_customer
70	Can add ShoppingHistory	24	add_shoppinghistory
71	Can change ShoppingHistory	24	change_shoppinghistory
72	Can delete ShoppingHistory	24	delete_shoppinghistory
73	Can add user	25	add_myuser
74	Can change user	25	change_myuser
75	Can delete user	25	delete_myuser
76	Can add user social auth	26	add_usersocialauth
77	Can change user social auth	26	change_usersocialauth
78	Can delete user social auth	26	delete_usersocialauth
79	Can add nonce	27	add_nonce
80	Can change nonce	27	change_nonce
81	Can delete nonce	27	delete_nonce
82	Can add association	28	add_association
83	Can change association	28	change_association
84	Can delete association	28	delete_association
85	Can add code	29	add_code
86	Can change code	29	change_code
87	Can delete code	29	delete_code
88	Can add PayPal NVP	30	add_paypalnvp
89	Can change PayPal NVP	30	change_paypalnvp
90	Can delete PayPal NVP	30	delete_paypalnvp
91	Can add Payment History	31	add_paymenthistory
92	Can change Payment History	31	change_paymenthistory
93	Can delete Payment History	31	delete_paymenthistory
\.


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_permission_id_seq', 93, true);


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$15000$YtTca4gMnwOF$cp7xhQmkxEqtPdXMNibE8pOuQhzR2+vn7/0aXxI//po=	2015-03-06 17:47:41.856664+01	t	admin	Radek	Juppa	rjuppa@gmail.com	t	t	2015-02-12 20:11:20.959978+01
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_id_seq', 1, true);


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('auth_user_user_permissions_id_seq', 1, false);


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2015-02-12 20:12:40.678051+01	4	Pilsner Urquell	1		18	1
2	2015-02-12 20:31:45.944295+01	1	Czech republic	1		16	1
3	2015-02-12 22:49:03.626099+01	4	Pilsner Urquell	2	Changed image.	18	1
4	2015-03-05 17:25:27.900036+01	5	Product ID: 5	1		22	1
5	2015-03-05 17:27:58.638783+01	6	Product ID: 6	1		22	1
6	2015-03-05 17:30:13.760669+01	7	Product ID: 7	1		22	1
7	2015-03-05 17:31:55.653148+01	8	Product ID: 8	1		22	1
8	2015-03-05 17:34:02.290101+01	9	Product ID: 9	1		22	1
9	2015-03-05 17:35:23.953422+01	10	Product ID: 10	1		22	1
10	2015-03-05 18:32:45.376074+01	1	Category object	1		21	1
11	2015-03-05 18:33:08.48118+01	10	Product ID: 10	2	Changed category.	22	1
12	2015-03-05 18:35:57.400274+01	9	Calmag Original 142g	2	Changed category.	22	1
13	2015-03-05 18:36:03.291498+01	8	Calmag Original 520 g	2	Changed category.	22	1
14	2015-03-05 18:36:08.773754+01	7	Magnesium carbonate	2	Changed category.	22	1
15	2015-03-05 18:36:13.709056+01	6	Calcium Gluconate	2	Changed category.	22	1
16	2015-03-05 18:36:19.496868+01	5	Vitamineral Komplex	2	Changed category.	22	1
17	2015-03-05 18:37:15.142667+01	10	Calmag Lemon	2	Changed active.	22	1
18	2015-03-05 18:37:19.458174+01	9	Calmag Original 142g	2	Changed active.	22	1
19	2015-03-05 18:37:23.42648+01	8	Calmag Original 520 g	2	Changed active.	22	1
20	2015-03-05 18:37:28.936141+01	7	Magnesium carbonate	2	Changed active.	22	1
21	2015-03-05 18:37:34.031907+01	6	Calcium Gluconate	2	Changed active.	22	1
22	2015-03-05 18:37:38.446467+01	5	Vitamineral Komplex	2	Changed active.	22	1
\.


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_admin_log_id_seq', 22, true);


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_content_type (id, name, app_label, model) FROM stdin;
1	log entry	admin	logentry
2	permission	auth	permission
3	group	auth	group
5	content type	contenttypes	contenttype
6	session	sessions	session
7	Cart	shop	cart
8	Cart item	shop	cartitem
9	Product	shop	product
10	Order	shop	order
11	Order item	shop	orderitem
12	Order extra info	shop	orderextrainfo
13	Extra order price field	shop	extraorderpricefield
14	Extra order item price field	shop	extraorderitempricefield
15	Order payment	shop	orderpayment
16	Country	addressmodel	country
17	Address	addressmodel	address
18	beer	beershop	beer
19	Country	shop	country
20	Address	shop	address
21	Category	vitashop	category
22	Product	vitashop	myproduct
23	Customer	vitashop	customer
24	ShoppingHistory	vitashop	shoppinghistory
25	user	vitashop	myuser
26	user social auth	default	usersocialauth
27	nonce	default	nonce
28	association	default	association
29	code	default	code
30	PayPal NVP	pro	paypalnvp
31	Payment History	vitashop	paymenthistory
\.


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_content_type_id_seq', 31, true);


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2015-02-12 19:39:43.894172+01
2	auth	0001_initial	2015-02-12 19:39:44.201324+01
3	admin	0001_initial	2015-02-12 19:39:44.335209+01
4	sessions	0001_initial	2015-02-12 19:39:44.419627+01
5	beershop	0001_initial	2015-02-12 20:03:51.555492+01
6	beershop	0002_beer_weight	2015-02-17 23:46:28.087883+01
7	vitashop	0001_initial	2015-03-05 17:08:09.295418+01
8	vitashop	0002_auto_20150306_0855	2015-03-06 09:56:01.907336+01
9	vitashop	0003_auto_20150306_2152	2015-03-06 22:52:27.057709+01
10	vitashop	0004_auto_20150306_2205	2015-03-06 23:06:25.377885+01
11	default	0001_initial	2015-03-07 01:16:45.457084+01
12	pro	0001_initial	2015-03-12 01:09:23.485329+01
13	pro	0002_auto_20141117_1647	2015-03-12 01:09:23.590082+01
14	vitashop	0005_paymenthistory	2015-03-13 14:46:21.366112+01
\.


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('django_migrations_id_seq', 14, true);


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY django_session (session_key, session_data, expire_date) FROM stdin;
xxq6d2o71f3gbrcz86vyjo5b6xukl10m	Y2FkMWJmYzVkNjZiMGQ4Y2FlOTA1MTRhZWRkZGEwODRmM2Q1YzZmNTp7Il9hdXRoX3VzZXJfaGFzaCI6IjgyOGM1NTQ4MjNiNjM3ZWIyYzZiNDZlZmIxYzliZmVmZTQyMzIyOGQiLCJfYXV0aF91c2VyX2JhY2tlbmQiOiJkamFuZ28uY29udHJpYi5hdXRoLmJhY2tlbmRzLk1vZGVsQmFja2VuZCIsIl9hdXRoX3VzZXJfaWQiOjF9	2015-02-26 20:11:57.731694+01
jko2v2g809tsu4scnzyth2cjemf5rr75	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 17:35:57.284561+01
fdwp81vn9biypfmq59ehg93c8cxznq3a	OTNmM2ZhOGVhZDk5ZDMzN2E5MjVhOWYyZWNlNzE1MzQxMGRkZTE0ZDp7fQ==	2015-03-20 17:29:18.505349+01
6giuf4kjcfiq319l2ormjk6mrzht6s9t	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 18:07:11.427192+01
0bx3l6gd7ds6vkxitkv1aucsmp5ev0sm	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 17:36:24.852351+01
d12oeyiufl04h7s8gl3iyltuyjssgjbd	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 18:08:42.713418+01
o81qlfbeeajrqvk0ot81tu07w2j4i0od	ZWU1YzNlN2Q0Yjk2M2I5NzkyZDhlYzM0ZDA1NjU4ZWNhMTVhNmQwNjp7ImZhY2Vib29rX3N0YXRlIjoiZUhiS0VpOVhMWnNRdmRvYkFiUlJLaEh6eFJIYXI2YzUiLCJleGNoYW5nZV9yYXRlIjoiKGRwMFxuUydidGNfaW5fZXVybydcbnAxXG5GMjUwLjk2OTJcbnNTJ3VwZGF0ZWQnXG5wMlxuUycyMDE1LTAzLTA3IDAwOjI0J1xucDNcbnNTJ2J0Y19pbl9kb2xsYXInXG5wNFxuRjI3Mi4xMzg5XG5zLiJ9	2015-03-21 19:02:48.965229+01
5cozgx28pcngqe9tahab4fao88x48wtb	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 17:39:21.008151+01
hn2whtg8lz0p628j7j1i5gr60y19uejj	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 17:42:23.212438+01
s5pb9dxrw1yblkbvf6t3yt2xlhvakgm5	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 17:42:51.899813+01
wr5pwvqduiulp8j9q407be209vd3l5qw	OTNmM2ZhOGVhZDk5ZDMzN2E5MjVhOWYyZWNlNzE1MzQxMGRkZTE0ZDp7fQ==	2015-03-21 23:28:43.762741+01
97kcfvcyhnrzpuyx24cc948o88pscate	MmI4YTYwMTk2MWE5MmMyZmQ0OTc3YmQxZDE1NDdlZGM1MmEwZmRmMTp7ImV4Y2hhbmdlX3JhdGUiOiIoZHAwXG5TJ2J0Y19pbl9ldXJvJ1xucDFcbkYyMDYuNTg5XG5zUyd1cGRhdGVkJ1xucDJcblMnMjAxNS0wMi0xOCAxODoxOCdcbnAzXG5zUydidGNfaW5fZG9sbGFyJ1xucDRcbkYyMzQuMjcxN1xucy4iLCJfYXV0aF91c2VyX2hhc2giOiI4MjhjNTU0ODIzYjYzN2ViMmM2YjQ2ZWZiMWM5YmZlZmU0MjMyMjhkIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2lkIjoxLCJjYXJ0X2lkIjozMX0=	2015-03-04 19:18:26.815421+01
oxbpl2sudbd0wg4cju0ynkhyie4po3no	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 17:49:39.575076+01
hc3f4e0fwi039v4nxho6gh3cq1wfdd0j	OWNjNmM2OWIzMzgxOTQwMGY1NTMzYzdiYTA5YTRhY2FjYTUzMDBhMzp7InBheW1lbnRfYmFja2VuZCI6InBheXBhbCIsIl9hdXRoX3VzZXJfaWQiOjEsInNoaXBwaW5nX2JhY2tlbmQiOiJjcG9zdGEiLCJmYWNlYm9va19zdGF0ZSI6Im93ejlkakR1U0JNc0poRGxhWlhSekx3VFhIMUw0Z3NJIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoic29jaWFsLmJhY2tlbmRzLmZhY2Vib29rLkZhY2Vib29rT0F1dGgyIiwiY3VycmVuY3kiOiJDWksiLCJzb2NpYWxfYXV0aF9sYXN0X2xvZ2luX2JhY2tlbmQiOiJmYWNlYm9vayIsIl9hdXRoX3VzZXJfaGFzaCI6ImZjOWFkNDY5ZDhmMGY1MDA0M2MxZTdlYTI4YTc4MDAwNjQ4NjkyMjUiLCJleGNoYW5nZV9yYXRlIjoiKGRwMFxuUydidGNfaW5fZXVybydcbnAxXG5GMjcwLjE2NjJcbnNTJ3VwZGF0ZWQnXG5wMlxuUycyMDE1LTAzLTE0IDE0OjQxJ1xucDNcbnNTJ2J0Y19pbl9kb2xsYXInXG5wNFxuRjI4My41NzYyXG5zLiIsImNhcnRfaWQiOjU2fQ==	2015-03-29 23:24:50.28+02
li0viqc12954rd49h3o5hqldzectbbgs	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 18:02:33.147905+01
rbxpn14n9wa13f3sgiczgpzqsfrsqnag	NGRkYjEzZGYxY2M5ZWZiZTNhOGQyNzQwZDU2YzJmN2E5ZWYyNTk0Zjp7InNvY2lhbF9hdXRoX2xhc3RfbG9naW5fYmFja2VuZCI6Imdvb2dsZS1wbHVzIiwiX2F1dGhfdXNlcl9oYXNoIjoiOGFkMTI5ZDBlNjc2ODc3Y2U2MzFkMGZmNjgxOWExOTdlNTJmNzgwZCIsIl9hdXRoX3VzZXJfYmFja2VuZCI6InNvY2lhbC5iYWNrZW5kcy5nb29nbGUuR29vZ2xlUGx1c0F1dGgiLCJfYXV0aF91c2VyX2lkIjoxfQ==	2015-03-22 18:03:42.246199+01
\.


--
-- Data for Name: shop_address; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_address (id, user_shipping_id, user_billing_id, name, address, address2, zip_code, city, state, country_id) FROM stdin;
2	1	1	Radek gmail	Street 8		12345	Pilsen	CA	1
1	8	8	aaaa	bbbbbb		12345	city		1
\.


--
-- Name: shop_address_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_address_id_seq', 2, true);


--
-- Data for Name: shop_cart; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_cart (id, user_id, date_created, last_updated) FROM stdin;
44	8	2015-03-10 00:24:51.818887+01	2015-03-10 00:24:51.834682+01
56	1	2015-03-14 14:30:32.986718+01	2015-03-15 22:19:21.024427+01
\.


--
-- Name: shop_cart_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_cart_id_seq', 56, true);


--
-- Data for Name: shop_cartitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_cartitem (id, cart_id, quantity, product_id) FROM stdin;
46	44	1	10
61	56	1	9
60	56	3	5
62	56	1	8
\.


--
-- Name: shop_cartitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_cartitem_id_seq', 62, true);


--
-- Data for Name: shop_country; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_country (id, name) FROM stdin;
1	Czech Republic
\.


--
-- Name: shop_country_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_country_id_seq', 1, false);


--
-- Data for Name: shop_extraorderitempricefield; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_extraorderitempricefield (id, order_item_id, label, value, data) FROM stdin;
\.


--
-- Name: shop_extraorderitempricefield_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_extraorderitempricefield_id_seq', 1, false);


--
-- Data for Name: shop_extraorderpricefield; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_extraorderpricefield (id, order_id, label, value, data, is_shipping) FROM stdin;
1	1	Flat shipping	10.00	\N	t
2	17	Flat shipping	10.00	\N	t
3	18	Flat shipping	10.00	\N	t
4	20	Flat shipping	10.00	\N	t
5	21	Flat shipping	10.00	\N	t
6	22	Flat shipping	10.00	\N	t
7	23	Flat shipping	10.00	\N	t
8	24	Flat shipping	10.00	\N	t
9	25	Flat shipping	10.00	\N	t
10	26	Flat shipping	10.00	\N	t
11	27	Flat shipping	10.00	\N	t
12	37	Flat shipping	0.00	\N	t
13	38	Flat shipping	0.00	\N	t
14	39	Shipping	2.00	\N	t
15	39	Flat shipping	0.00	\N	t
16	40	Flat shipping	0.00	\N	t
17	41	Flat shipping	0.00	\N	t
18	42	Shipping	-3.00	\N	t
19	42	Flat shipping	0.00	\N	t
20	43	Flat shipping	0.00	\N	t
21	44	Flat shipping	0.00	\N	t
22	45	Flat shipping	0.00	\N	t
23	46	Flat shipping	0.00	\N	t
24	47	Flat shipping	0.00	\N	t
25	48	My awesome rebate	-30.00	\N	f
26	48	Flat shipping	0.00	\N	t
27	50	Flat shipping	0.00	\N	t
34	54	Shipping	-0.02	\N	t
35	54	Shipping	-0.03	\N	t
33	54	Flat shipping	0.00	\N	t
36	55	Flat shipping	0.00	\N	t
37	56	Flat shipping	0.00	\N	t
38	57	Flat shipping	0.00	\N	t
39	58	Flat shipping	0.00	\N	t
40	59	Flat shipping	0.00	\N	t
41	62	Personal pickup	0.00	\N	t
42	63	Personal pickup	0.00	\N	t
43	64	Personal pickup	0.00	\N	t
44	65	Personal pickup	0.00	\N	t
45	66	Personal pickup	0.00	\N	t
46	67	Personal pickup	0.00	\N	t
47	68	Personal pickup	0.00	\N	t
48	70	Personal pickup	0.00	\N	t
59	92	Shipping	145.00	\N	t
64	97	Shipping	145.00	\N	t
68	102	Shipping	0.50	\N	t
69	103	Shipping	0.50	\N	t
70	104	Shipping	0.50	\N	t
71	105	Shipping	0.50	\N	t
72	106	Shipping	0.50	\N	t
73	107	Shipping	0.50	\N	t
74	108	Shipping	0.50	\N	t
75	109	Shipping	0.50	\N	t
76	110	Shipping	0.50	\N	t
77	111	Shipping	0.50	\N	t
78	112	Shipping	0.50	\N	t
79	113	Shipping	0.50	\N	t
81	115	Shipping	0.50	\N	t
\.


--
-- Name: shop_extraorderpricefield_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_extraorderpricefield_id_seq', 81, true);


--
-- Data for Name: shop_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_order (id, user_id, status, order_subtotal, order_total, shipping_address_text, billing_address_text, created, modified, cart_pk, country_id) FROM stdin;
20	1	30	2.24	12.24	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 17:37:24.456457+01	2015-02-14 17:37:26.24483+01	6	\N
1	1	40	1.12	11.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-13 23:26:07.582072+01	2015-02-13 23:26:16.503908+01	3	\N
17	1	40	2.24	12.24	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 15:13:43.934254+01	2015-02-14 15:14:40.530066+01	5	\N
26	1	30	1.12	11.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 23:33:11.416681+01	2015-02-14 23:34:12.268834+01	11	\N
43	1	30	0.01	0.01	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-17 21:22:01.086208+01	2015-02-17 21:25:16.019935+01	19	\N
24	1	30	1.12	11.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 20:53:05.002276+01	2015-02-14 20:53:06.886094+01	9	\N
21	1	30	1.12	11.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 20:50:05.839962+01	2015-02-14 20:51:07.855479+01	7	\N
38	1	30	1.12	1.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-15 14:10:10.240741+01	2015-02-15 14:10:22.668479+01	14	\N
18	1	30	2.24	12.24	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 17:33:48.026382+01	2015-02-14 17:37:11.308348+01	6	\N
27	1	30	1.12	11.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 23:34:22.327716+01	2015-02-14 23:34:24.040652+01	12	\N
22	1	40	1.12	11.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 20:51:17.038924+01	2015-02-14 20:51:19.398118+01	7	\N
25	1	40	1.12	11.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 23:32:47.320023+01	2015-02-14 23:32:49.626612+01	10	\N
40	1	30	1.12	4.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-15 14:20:04.063049+01	2015-02-15 14:20:12.043048+01	16	\N
23	1	30	1.12	11.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-14 20:51:39.575002+01	2015-02-14 20:51:41.842693+01	8	\N
45	1	30	0.01	0.03	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-17 21:40:24.586072+01	2015-02-17 21:40:27.914731+01	21	\N
42	1	30	1.12	2.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-15 14:20:45.653054+01	2015-02-15 14:20:50.983828+01	18	\N
37	1	30	2.24	2.24	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-15 14:04:19.205922+01	2015-02-15 14:09:40.855231+01	13	\N
39	1	30	1.12	-1.88	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-15 14:16:05.786453+01	2015-02-15 14:19:05.323061+01	15	\N
44	1	30	0.01	0.03	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-17 21:36:57.761419+01	2015-02-17 21:40:14.446723+01	20	\N
41	1	30	1.12	3.12	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-15 14:20:26.391694+01	2015-02-15 14:20:35.123505+01	17	\N
48	1	30	300.01	270.03	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-17 21:57:52.689357+01	2015-02-17 21:57:59.903549+01	24	\N
46	1	30	0.01	0.03	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-17 21:42:40.736015+01	2015-02-17 21:56:29.501471+01	22	\N
47	1	30	0.01	0.03	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-17 21:56:38.773975+01	2015-02-17 21:56:44.816408+01	23	\N
50	1	30	600.02	600.04	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-18 00:21:21.056378+01	2015-02-18 00:21:46.333739+01	25	1
54	1	30	300.01	300.02	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-18 00:35:54.859978+01	2015-02-18 00:36:04.961192+01	26	1
55	1	30	0.20	0.21	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-18 12:42:11.974092+01	2015-02-18 12:43:49.299125+01	27	1
56	1	30	0.20	0.21	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-18 13:02:13.7706+01	2015-02-18 13:02:49.602172+01	28	1
57	1	30	0.20	0.21	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-18 13:07:59.257553+01	2015-02-18 13:08:06.201683+01	29	1
58	1	30	0.20	0.21	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-18 18:48:07.042914+01	2015-02-18 18:48:15.80777+01	30	1
68	8	30	24.00	24.00	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	2015-03-10 00:27:21.696469+01	2015-03-10 00:27:29.391217+01	44	1
62	8	30	24.00	24.00	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	2015-03-09 22:53:25.305364+01	2015-03-09 23:56:59.375479+01	40	1
59	1	30	0.20	0.23	\nName: radek,\nAddress: aaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	\nName: radek,\nAddress: aaaaa\n,\nZip-Code: 432,\nCity: city,\nState: st,\nCountry: Czech republic\n	2015-02-18 19:18:20.667863+01	2015-02-18 19:18:26.748881+01	31	1
65	8	30	24.00	24.00	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	2015-03-10 00:21:33.392265+01	2015-03-10 00:24:30.436817+01	43	1
106	1	40	1.00	1.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-13 23:41:06.636786+01	2015-03-13 23:41:56.411429+01	50	1
63	8	30	24.00	24.00	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	2015-03-09 23:59:13.933117+01	2015-03-10 00:03:51.605014+01	41	1
66	8	30	24.00	24.00	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	2015-03-10 00:24:33.701304+01	2015-03-10 00:24:40.247525+01	43	1
64	8	30	24.00	24.00	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	2015-03-10 00:03:59.778723+01	2015-03-10 00:04:11.87088+01	42	1
97	1	20	50.00	195.00	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-13 22:45:25.344853+01	2015-03-13 22:45:26.780065+01	45	1
92	1	30	50.00	195.00	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-11 18:36:45.004399+01	2015-03-11 18:52:06.582343+01	45	1
70	8	30	24.00	24.00	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	2015-03-10 00:39:53.768396+01	2015-03-10 00:40:58.867655+01	44	1
67	8	30	24.00	24.00	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	\nName: aaaa,\nAddress: bbbbbb\n,\nZip-Code: 12345,\nCity: city,\nState: ,\nCountry: Czech Republic\n	2015-03-10 00:24:54.740236+01	2015-03-10 00:27:13.034281+01	44	1
103	1	40	1.00	1.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-13 23:32:39.87942+01	2015-03-13 23:35:10.538489+01	47	1
105	1	40	25.00	25.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-13 23:39:41.065115+01	2015-03-13 23:40:33.353374+01	49	1
102	1	40	2.40	2.90	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-13 23:09:50.160176+01	2015-03-13 23:32:21.827994+01	46	1
104	1	40	9.00	9.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-13 23:37:23.493544+01	2015-03-13 23:39:22.205332+01	48	1
107	1	40	25.00	25.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-13 23:42:25.427737+01	2015-03-14 00:01:35.4513+01	51	1
108	1	40	20.00	20.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-14 00:10:35.84965+01	2015-03-14 00:15:08.90354+01	52	1
109	1	40	29.00	29.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-14 00:15:34.66042+01	2015-03-14 00:18:51.919762+01	53	1
110	1	40	26.00	26.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-14 00:27:38.581718+01	2015-03-14 00:32:38.378367+01	54	1
111	1	30	25.00	25.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-14 00:37:00.669838+01	2015-03-14 00:37:04.390829+01	55	1
112	1	30	25.00	25.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-14 00:59:52.370867+01	2015-03-14 00:59:54.863594+01	55	1
113	1	40	25.00	25.50	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-14 01:07:46.919395+01	2015-03-14 01:08:35.647067+01	55	1
115	1	30	4.40	4.90	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	{"city": "Pilsen", "name": "Radek gmail", "country": "Czech Republic", "address2": "", "state": "CA", "address": "Street 8", "zip_code": "12345"}	2015-03-15 22:24:49.118605+01	2015-03-15 22:43:37.465106+01	56	1
\.


--
-- Name: shop_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_order_id_seq', 115, true);


--
-- Data for Name: shop_orderextrainfo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_orderextrainfo (id, order_id, text) FROM stdin;
1	1	ahoj
5	17	aaa
6	18	ccc
7	20	ccc
8	21	aaa
9	50	ccc
13	54	fff
\.


--
-- Name: shop_orderextrainfo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_orderextrainfo_id_seq', 13, true);


--
-- Data for Name: shop_orderitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_orderitem (id, order_id, product_reference, product_name, product_id, unit_price, quantity, line_subtotal, line_total) FROM stdin;
1	1	4	Pilsner Urquell	4	1.12	1	1.12	1.12
110	102	5	Vitamineral Komplex	5	1.00	1	1.00	1.00
111	102	9	Calmag Original 142g	9	0.40	1	0.40	0.40
112	102	10	Calmag Lemon	10	1.00	1	1.00	1.00
113	103	5	Vitamineral Komplex	5	1.00	1	1.00	1.00
114	104	5	Vitamineral Komplex	5	1.00	9	9.00	9.00
115	105	5	Vitamineral Komplex	5	1.00	25	25.00	25.00
116	106	5	Vitamineral Komplex	5	1.00	1	1.00	1.00
117	107	5	Vitamineral Komplex	5	1.00	25	25.00	25.00
118	108	5	Vitamineral Komplex	5	1.00	20	20.00	20.00
17	17	4	Pilsner Urquell	4	1.12	2	2.24	2.24
18	18	4	Pilsner Urquell	4	1.12	2	2.24	2.24
119	109	5	Vitamineral Komplex	5	1.00	29	29.00	29.00
20	20	4	Pilsner Urquell	4	1.12	2	2.24	2.24
21	21	4	Pilsner Urquell	4	1.12	1	1.12	1.12
22	22	4	Pilsner Urquell	4	1.12	1	1.12	1.12
23	23	4	Pilsner Urquell	4	1.12	1	1.12	1.12
24	24	4	Pilsner Urquell	4	1.12	1	1.12	1.12
25	25	4	Pilsner Urquell	4	1.12	1	1.12	1.12
26	26	4	Pilsner Urquell	4	1.12	1	1.12	1.12
27	27	4	Pilsner Urquell	4	1.12	1	1.12	1.12
120	110	5	Vitamineral Komplex	5	1.00	26	26.00	26.00
121	111	5	Vitamineral Komplex	5	1.00	25	25.00	25.00
122	112	5	Vitamineral Komplex	5	1.00	25	25.00	25.00
123	113	5	Vitamineral Komplex	5	1.00	25	25.00	25.00
127	115	9	Calmag Original 142g	9	0.40	1	0.40	0.40
128	115	5	Vitamineral Komplex	5	1.00	3	3.00	3.00
37	37	4	Pilsner Urquell	4	1.12	2	2.24	2.24
38	38	4	Pilsner Urquell	4	1.12	1	1.12	1.12
39	39	4	Pilsner Urquell	4	1.12	1	1.12	1.12
40	40	4	Pilsner Urquell	4	1.12	1	1.12	1.12
41	41	4	Pilsner Urquell	4	1.12	1	1.12	1.12
42	42	4	Pilsner Urquell	4	1.12	1	1.12	1.12
43	43	4	Pilsner Urquell	4	0.01	1	0.01	0.01
44	44	4	Pilsner Urquell	4	0.01	1	0.01	0.01
45	45	4	Pilsner Urquell	4	0.01	1	0.01	0.01
46	46	4	Pilsner Urquell	4	0.01	1	0.01	0.01
47	47	4	Pilsner Urquell	4	0.01	1	0.01	0.01
48	48	4	Pilsner Urquell	4	300.01	1	300.01	300.01
129	115	8	Calmag Original 520 g	8	1.00	1	1.00	1.00
50	50	4	Pilsner Urquell	4	300.01	2	600.02	600.02
54	54	4	Pilsner Urquell	4	300.01	1	300.01	300.01
55	55	4	Pilsner Urquell	4	0.20	1	0.20	0.20
56	56	4	Pilsner Urquell	4	0.20	1	0.20	0.20
57	57	4	Pilsner Urquell	4	0.20	1	0.20	0.20
58	58	4	Pilsner Urquell	4	0.20	1	0.20	0.20
59	59	4	Pilsner Urquell	4	0.20	1	0.20	0.20
62	62	10	Calmag Lemon	10	24.00	1	24.00	24.00
63	63	10	Calmag Lemon	10	24.00	1	24.00	24.00
64	64	10	Calmag Lemon	10	24.00	1	24.00	24.00
65	65	10	Calmag Lemon	10	24.00	1	24.00	24.00
66	66	10	Calmag Lemon	10	24.00	1	24.00	24.00
67	67	10	Calmag Lemon	10	24.00	1	24.00	24.00
68	68	10	Calmag Lemon	10	24.00	1	24.00	24.00
70	70	10	Calmag Lemon	10	24.00	1	24.00	24.00
92	92	9	Calmag Original 142g	9	25.00	2	50.00	50.00
97	97	9	Calmag Original 142g	9	25.00	2	50.00	50.00
\.


--
-- Name: shop_orderitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_orderitem_id_seq', 129, true);


--
-- Data for Name: shop_orderpayment; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_orderpayment (id, order_id, amount, transaction_id, payment_method) FROM stdin;
5	102	2.90		paypal
6	103	1.50		paypal
7	104	9.50		paypal
8	105	25.50		paypal
9	106	1.50		paypal
10	107	25.50		paypal
11	108	20.50		paypal
12	109	29.50		paypal
13	110	26.50		paypal
14	111	19.95		paypal
15	111	19.95		paypal
16	111	19.95		paypal
17	112	19.95		paypal
18	113	25.50		paypal
\.


--
-- Name: shop_orderpayment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_orderpayment_id_seq', 18, true);


--
-- Data for Name: shop_product; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY shop_product (id, polymorphic_ctype_id, name, slug, active, date_added, last_modified, unit_price) FROM stdin;
4	18	Pilsner Urquell	P12	t	2015-02-12 20:12:40.671307+01	2015-02-12 22:49:03.621118+01	0.20
5	22	Vitamineral Komplex	vitamineral-komplex	t	2015-03-05 17:25:27.893226+01	2015-03-05 18:37:38.442398+01	1.00
6	22	Calcium Gluconate	calcium-gluconate	t	2015-03-05 17:27:58.632691+01	2015-03-05 18:37:34.027803+01	1.00
7	22	Magnesium carbonate	magnesium	t	2015-03-05 17:30:13.754652+01	2015-03-05 18:37:28.927236+01	1.00
8	22	Calmag Original 520 g	calmag-original-520g	t	2015-03-05 17:31:55.648289+01	2015-03-05 18:37:23.417773+01	1.00
10	22	Calmag Lemon	calmag-lemon	t	2015-03-05 17:35:23.948496+01	2015-03-05 18:37:15.138593+01	1.00
9	22	Calmag Original 142g	calmag-original-142g	t	2015-03-05 17:34:02.28351+01	2015-03-05 18:37:19.454159+01	0.40
\.


--
-- Name: shop_product_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('shop_product_id_seq', 10, true);


--
-- Data for Name: social_auth_association; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY social_auth_association (id, server_url, handle, secret, issued, lifetime, assoc_type) FROM stdin;
\.


--
-- Name: social_auth_association_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('social_auth_association_id_seq', 1, false);


--
-- Data for Name: social_auth_code; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY social_auth_code (id, email, code, verified) FROM stdin;
\.


--
-- Name: social_auth_code_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('social_auth_code_id_seq', 1, false);


--
-- Data for Name: social_auth_nonce; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY social_auth_nonce (id, server_url, "timestamp", salt) FROM stdin;
\.


--
-- Name: social_auth_nonce_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('social_auth_nonce_id_seq', 1, false);


--
-- Data for Name: social_auth_usersocialauth; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY social_auth_usersocialauth (id, provider, uid, extra_data, user_id) FROM stdin;
3	google-plus	radek.juppa@syntacticsugar.com	{"code": null, "user_id": "102310298014809454867", "access_token": "ya29.MAFekk37guqeS2HB1kfh7MUvbmqsmOto-NFW-ceiT9qynq1KOgA_-EBmkcs1PDAsS-dWBFWyCHcIHA", "expires": 3599}	8
2	google-plus	rjuppa@gmail.com	{"code": null, "user_id": "108097754371307798638", "access_token": "ya29.MgF1eXNA-yr-SGTGbl6zLgPSSrnlzD62NeREJRkAib6EUiDf-00HabyVAM2gjX2EsJuGGPYilEoGBA", "expires": 3599}	1
1	facebook	10152701348503148	{"access_token": "CAAHd2kcGmhcBABLYPO6TIlc8bqoS0XhwIWIrhRhMr3q9Y5ZA3mQWj4kejcyxd04tgghbOemFzbDpuJZA9vxZBkqPDY2NVAoLGeLEeqnaLmK0nXfWqkDlbZCqzMTFWMDXxv3PddJVqcRNpDD0X7pwhIJDlw1h1cznrqYbsHvZBH9K2RfRrU8wxDfGHPHWe0IgzjUr7ZBdg3VnEZA2BWZALN4C", "expires": "5184000", "id": "10152701348503148"}	1
\.


--
-- Name: social_auth_usersocialauth_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('social_auth_usersocialauth_id_seq', 3, true);


--
-- Data for Name: vitashop_category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vitashop_category (id, name, slug, active, image, intro, created) FROM stdin;
1	Vitamins	vitamins	t			2015-03-05 18:32:45.371858+01
\.


--
-- Name: vitashop_category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vitashop_category_id_seq', 1, true);


--
-- Data for Name: vitashop_customer; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vitashop_customer (id, email, language, currency, newsletter, discount, parent_id, user_id) FROM stdin;
\.


--
-- Name: vitashop_customer_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vitashop_customer_id_seq', 1, false);


--
-- Data for Name: vitashop_myproduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vitashop_myproduct (product_ptr_id, image, intro, link, desc1, desc2, desc3, filter1, filter2, is_featured, weight, old_price, discount, ordering, category_id) FROM stdin;
5	vitaminy_velke.jpg	Vitamineral Komplex daily							f	300.00	0.00	0.00	1	1
10	calmag_lemon.jpg	Calmag Lemon je vhodný pro všechny dospělé. Navíc obsahuje vitamín C a přírodní sušenou citronovou šťávu, což mu dodává osvěžující chuť.							f	0.00	0.00	0.00	2	1
9	calmag_orig.jpg	Calmag Original malé balení 1-2 měsíce							f	0.00	0.00	0.00	3	1
8	calmag_velky.jpg	Calmag Original velké balení 4-6 měsíců							f	0.00	0.00	0.00	4	1
7	magnesium.jpg	Magnesium carbonate Hořčík- 84 g							f	0.00	0.00	0.00	5	1
6	calcium.jpg	Calcium Gluconate Vápník- 420 g							f	420.00	0.00	0.00	6	1
\.


--
-- Data for Name: vitashop_myuser; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vitashop_myuser (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$15000$YOPlsLinRU6h$hc92G5ks/MYaXWthUpCGGH7Srf+pABJ21WcdZZdqasI=	2015-03-10 20:44:24.723097+01	f	JoeBobson	Joe	Bobson	rjuppa@gmail.com	f	t	2015-03-07 19:31:01.778213+01
8	pbkdf2_sha256$15000$BaZLG7dowdJx$2ueMwi+L9ccxtpmPNvXouRhvOOkOgrhFWxWifF/Qa7o=	2015-03-09 12:34:36.364752+01	f	radek.juppa	Radek	Juppa	radek.juppa@syntacticsugar.com	f	t	2015-03-09 11:50:40.025954+01
9	pbkdf2_sha256$15000$1311fKxPxZlv$bpM8J/8FWiQHbaTaQr1cuYBcH82aUwzdo6D/HZV3ZLo=	2015-03-10 11:30:14.881662+01	f				aaa@aaa.cc	f	t	2015-03-10 11:30:14.881754+01
\.


--
-- Data for Name: vitashop_myuser_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vitashop_myuser_groups (id, myuser_id, group_id) FROM stdin;
\.


--
-- Name: vitashop_myuser_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vitashop_myuser_groups_id_seq', 1, false);


--
-- Name: vitashop_myuser_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vitashop_myuser_id_seq', 9, true);


--
-- Data for Name: vitashop_myuser_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vitashop_myuser_user_permissions (id, myuser_id, permission_id) FROM stdin;
\.


--
-- Name: vitashop_myuser_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vitashop_myuser_user_permissions_id_seq', 1, false);


--
-- Data for Name: vitashop_paymenthistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vitashop_paymenthistory (orderpayment_ptr_id, email, currency, result, wallet_address, status, created) FROM stdin;
5	rjuppa@gmail.com	USD	canceled	\N	10	2015-03-13 23:11:41.876078+01
6	rjuppa@gmail.com	USD	success	\N	10	2015-03-13 23:32:46.16905+01
7	rjuppa@gmail.com	USD	success	\N	10	2015-03-13 23:37:29.853109+01
8	rjuppa@gmail.com	USD	success	\N	10	2015-03-13 23:39:45.042424+01
9	rjuppa@gmail.com	USD	canceled	\N	10	2015-03-13 23:41:10.862615+01
10	rjuppa@gmail.com	USD	success	\N	10	2015-03-13 23:59:34.259881+01
11	rjuppa@gmail.com	USD	canceled	\N	10	2015-03-14 00:10:42.322946+01
12	rjuppa@gmail.com	USD	success	\N	10	2015-03-14 00:15:41.673969+01
13	rjuppa@gmail.com	USD	failed	\N	10	2015-03-14 00:28:02.071779+01
14	rjuppa@gmail.com	USD	failed	\N	10	2015-03-14 00:40:12.723669+01
15	rjuppa@gmail.com	USD	place_order	\N	10	2015-03-14 00:44:47.430706+01
16	rjuppa@gmail.com	USD	place_order	\N	10	2015-03-14 00:52:24.214123+01
17	rjuppa@gmail.com	USD	success	\N	10	2015-03-14 00:59:56.196324+01
18	rjuppa@gmail.com	USD	success	\N	10	2015-03-14 01:07:58.32963+01
\.


--
-- Data for Name: vitashop_shoppinghistory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY vitashop_shoppinghistory (id, quantity, created, customer_id, product_id) FROM stdin;
\.


--
-- Name: vitashop_shoppinghistory_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('vitashop_shoppinghistory_id_seq', 1, false);


--
-- Name: addressmodel_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY addressmodel_address
    ADD CONSTRAINT addressmodel_address_pkey PRIMARY KEY (id);


--
-- Name: addressmodel_address_user_billing_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY addressmodel_address
    ADD CONSTRAINT addressmodel_address_user_billing_id_key UNIQUE (user_billing_id);


--
-- Name: addressmodel_address_user_shipping_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY addressmodel_address
    ADD CONSTRAINT addressmodel_address_user_shipping_id_key UNIQUE (user_shipping_id);


--
-- Name: addressmodel_country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY addressmodel_country
    ADD CONSTRAINT addressmodel_country_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions_group_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_key UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission_content_type_id_codename_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_key UNIQUE (content_type_id, codename);


--
-- Name: auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions_user_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_key UNIQUE (user_id, permission_id);


--
-- Name: auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type_app_label_45f3b1d93ec8c61c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_app_label_45f3b1d93ec8c61c_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: shop_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_address
    ADD CONSTRAINT shop_address_pkey PRIMARY KEY (id);


--
-- Name: shop_address_user_billing_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_address
    ADD CONSTRAINT shop_address_user_billing_id_key UNIQUE (user_billing_id);


--
-- Name: shop_address_user_shipping_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_address
    ADD CONSTRAINT shop_address_user_shipping_id_key UNIQUE (user_shipping_id);


--
-- Name: shop_cart_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_cart
    ADD CONSTRAINT shop_cart_pkey PRIMARY KEY (id);


--
-- Name: shop_cart_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_cart
    ADD CONSTRAINT shop_cart_user_id_key UNIQUE (user_id);


--
-- Name: shop_cartitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_cartitem
    ADD CONSTRAINT shop_cartitem_pkey PRIMARY KEY (id);


--
-- Name: shop_country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_country
    ADD CONSTRAINT shop_country_pkey PRIMARY KEY (id);


--
-- Name: shop_extraorderitempricefield_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_extraorderitempricefield
    ADD CONSTRAINT shop_extraorderitempricefield_pkey PRIMARY KEY (id);


--
-- Name: shop_extraorderpricefield_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_extraorderpricefield
    ADD CONSTRAINT shop_extraorderpricefield_pkey PRIMARY KEY (id);


--
-- Name: shop_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_order
    ADD CONSTRAINT shop_order_pkey PRIMARY KEY (id);


--
-- Name: shop_orderextrainfo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_orderextrainfo
    ADD CONSTRAINT shop_orderextrainfo_pkey PRIMARY KEY (id);


--
-- Name: shop_orderitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_orderitem
    ADD CONSTRAINT shop_orderitem_pkey PRIMARY KEY (id);


--
-- Name: shop_orderpayment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_orderpayment
    ADD CONSTRAINT shop_orderpayment_pkey PRIMARY KEY (id);


--
-- Name: shop_product_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_product
    ADD CONSTRAINT shop_product_pkey PRIMARY KEY (id);


--
-- Name: shop_product_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY shop_product
    ADD CONSTRAINT shop_product_slug_key UNIQUE (slug);


--
-- Name: social_auth_association_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY social_auth_association
    ADD CONSTRAINT social_auth_association_pkey PRIMARY KEY (id);


--
-- Name: social_auth_code_email_75f27066d057e3b6_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY social_auth_code
    ADD CONSTRAINT social_auth_code_email_75f27066d057e3b6_uniq UNIQUE (email, code);


--
-- Name: social_auth_code_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY social_auth_code
    ADD CONSTRAINT social_auth_code_pkey PRIMARY KEY (id);


--
-- Name: social_auth_nonce_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY social_auth_nonce
    ADD CONSTRAINT social_auth_nonce_pkey PRIMARY KEY (id);


--
-- Name: social_auth_nonce_server_url_36601f978463b4_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY social_auth_nonce
    ADD CONSTRAINT social_auth_nonce_server_url_36601f978463b4_uniq UNIQUE (server_url, "timestamp", salt);


--
-- Name: social_auth_usersocialauth_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY social_auth_usersocialauth
    ADD CONSTRAINT social_auth_usersocialauth_pkey PRIMARY KEY (id);


--
-- Name: social_auth_usersocialauth_provider_2f763109e2c4a1fb_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY social_auth_usersocialauth
    ADD CONSTRAINT social_auth_usersocialauth_provider_2f763109e2c4a1fb_uniq UNIQUE (provider, uid);


--
-- Name: vitashop_category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_category
    ADD CONSTRAINT vitashop_category_pkey PRIMARY KEY (id);


--
-- Name: vitashop_category_slug_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_category
    ADD CONSTRAINT vitashop_category_slug_key UNIQUE (slug);


--
-- Name: vitashop_customer_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_customer
    ADD CONSTRAINT vitashop_customer_email_key UNIQUE (email);


--
-- Name: vitashop_customer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_customer
    ADD CONSTRAINT vitashop_customer_pkey PRIMARY KEY (id);


--
-- Name: vitashop_customer_user_id_2858446cca0af12b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_customer
    ADD CONSTRAINT vitashop_customer_user_id_2858446cca0af12b_uniq UNIQUE (user_id);


--
-- Name: vitashop_myproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_myproduct
    ADD CONSTRAINT vitashop_myproduct_pkey PRIMARY KEY (product_ptr_id);


--
-- Name: vitashop_myuser_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_myuser
    ADD CONSTRAINT vitashop_myuser_email_key UNIQUE (email);


--
-- Name: vitashop_myuser_groups_myuser_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_myuser_groups
    ADD CONSTRAINT vitashop_myuser_groups_myuser_id_group_id_key UNIQUE (myuser_id, group_id);


--
-- Name: vitashop_myuser_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_myuser_groups
    ADD CONSTRAINT vitashop_myuser_groups_pkey PRIMARY KEY (id);


--
-- Name: vitashop_myuser_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_myuser
    ADD CONSTRAINT vitashop_myuser_pkey PRIMARY KEY (id);


--
-- Name: vitashop_myuser_user_permissions_myuser_id_permission_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_myuser_user_permissions
    ADD CONSTRAINT vitashop_myuser_user_permissions_myuser_id_permission_id_key UNIQUE (myuser_id, permission_id);


--
-- Name: vitashop_myuser_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_myuser_user_permissions
    ADD CONSTRAINT vitashop_myuser_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: vitashop_myuser_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_myuser
    ADD CONSTRAINT vitashop_myuser_username_key UNIQUE (username);


--
-- Name: vitashop_paymenthistory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_paymenthistory
    ADD CONSTRAINT vitashop_paymenthistory_pkey PRIMARY KEY (orderpayment_ptr_id);


--
-- Name: vitashop_paymenthistory_wallet_address_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_paymenthistory
    ADD CONSTRAINT vitashop_paymenthistory_wallet_address_key UNIQUE (wallet_address);


--
-- Name: vitashop_shoppinghistory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY vitashop_shoppinghistory
    ADD CONSTRAINT vitashop_shoppinghistory_pkey PRIMARY KEY (id);


--
-- Name: addressmodel_address_country_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX addressmodel_address_country_id ON addressmodel_address USING btree (country_id);


--
-- Name: auth_group_name_253ae2a6331666e8_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_group_name_253ae2a6331666e8_like ON auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_0e939a4f; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_group_permissions_0e939a4f ON auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_8373b171; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_group_permissions_8373b171 ON auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_417f1b1c; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_permission_417f1b1c ON auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_0e939a4f; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_user_groups_0e939a4f ON auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_e8701ad4; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_user_groups_e8701ad4 ON auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_8373b171; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_8373b171 ON auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_e8701ad4; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_user_user_permissions_e8701ad4 ON auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_51b3b110094b8aae_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX auth_user_username_51b3b110094b8aae_like ON auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_417f1b1c; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX django_admin_log_417f1b1c ON django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_e8701ad4; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX django_admin_log_e8701ad4 ON django_admin_log USING btree (user_id);


--
-- Name: django_session_de54fa62; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX django_session_de54fa62 ON django_session USING btree (expire_date);


--
-- Name: django_session_session_key_461cfeaa630ca218_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX django_session_session_key_461cfeaa630ca218_like ON django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: fki_order_country; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX fki_order_country ON shop_order USING btree (country_id);


--
-- Name: shop_address_country_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_address_country_id ON shop_address USING btree (country_id);


--
-- Name: shop_cartitem_cart_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_cartitem_cart_id ON shop_cartitem USING btree (cart_id);


--
-- Name: shop_cartitem_product_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_cartitem_product_id ON shop_cartitem USING btree (product_id);


--
-- Name: shop_extraorderitempricefield_order_item_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_extraorderitempricefield_order_item_id ON shop_extraorderitempricefield USING btree (order_item_id);


--
-- Name: shop_extraorderpricefield_order_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_extraorderpricefield_order_id ON shop_extraorderpricefield USING btree (order_id);


--
-- Name: shop_order_user_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_order_user_id ON shop_order USING btree (user_id);


--
-- Name: shop_orderextrainfo_order_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_orderextrainfo_order_id ON shop_orderextrainfo USING btree (order_id);


--
-- Name: shop_orderitem_order_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_orderitem_order_id ON shop_orderitem USING btree (order_id);


--
-- Name: shop_orderitem_product_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_orderitem_product_id ON shop_orderitem USING btree (product_id);


--
-- Name: shop_orderpayment_order_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_orderpayment_order_id ON shop_orderpayment USING btree (order_id);


--
-- Name: shop_product_polymorphic_ctype_id; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_product_polymorphic_ctype_id ON shop_product USING btree (polymorphic_ctype_id);


--
-- Name: shop_product_slug_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX shop_product_slug_like ON shop_product USING btree (slug varchar_pattern_ops);


--
-- Name: social_auth_code_c1336794; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX social_auth_code_c1336794 ON social_auth_code USING btree (code);


--
-- Name: social_auth_code_code_32d820bdeaa954bc_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX social_auth_code_code_32d820bdeaa954bc_like ON social_auth_code USING btree (code varchar_pattern_ops);


--
-- Name: vitashop_category_slug_4a99060323fb24e0_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_category_slug_4a99060323fb24e0_like ON vitashop_category USING btree (slug varchar_pattern_ops);


--
-- Name: vitashop_customer_6be37982; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_customer_6be37982 ON vitashop_customer USING btree (parent_id);


--
-- Name: vitashop_customer_e8701ad4; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_customer_e8701ad4 ON vitashop_customer USING btree (user_id);


--
-- Name: vitashop_customer_email_769270f0272fad60_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_customer_email_769270f0272fad60_like ON vitashop_customer USING btree (email varchar_pattern_ops);


--
-- Name: vitashop_myproduct_b583a629; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_myproduct_b583a629 ON vitashop_myproduct USING btree (category_id);


--
-- Name: vitashop_myuser_email_4380f8831fb45773_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_myuser_email_4380f8831fb45773_like ON vitashop_myuser USING btree (email varchar_pattern_ops);


--
-- Name: vitashop_myuser_groups_0e939a4f; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_myuser_groups_0e939a4f ON vitashop_myuser_groups USING btree (group_id);


--
-- Name: vitashop_myuser_groups_8b14fb18; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_myuser_groups_8b14fb18 ON vitashop_myuser_groups USING btree (myuser_id);


--
-- Name: vitashop_myuser_user_permissions_8373b171; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_myuser_user_permissions_8373b171 ON vitashop_myuser_user_permissions USING btree (permission_id);


--
-- Name: vitashop_myuser_user_permissions_8b14fb18; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_myuser_user_permissions_8b14fb18 ON vitashop_myuser_user_permissions USING btree (myuser_id);


--
-- Name: vitashop_myuser_username_45e8b288df99b006_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_myuser_username_45e8b288df99b006_like ON vitashop_myuser USING btree (username varchar_pattern_ops);


--
-- Name: vitashop_paymenthistory_wallet_address_1849e352e82ade95_like; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_paymenthistory_wallet_address_1849e352e82ade95_like ON vitashop_paymenthistory USING btree (wallet_address varchar_pattern_ops);


--
-- Name: vitashop_shoppinghistory_9bea82de; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_shoppinghistory_9bea82de ON vitashop_shoppinghistory USING btree (product_id);


--
-- Name: vitashop_shoppinghistory_cb24373b; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE INDEX vitashop_shoppinghistory_cb24373b ON vitashop_shoppinghistory USING btree (customer_id);


--
-- Name: D885be08a4a741c0553d7089a1be4853; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_shoppinghistory
    ADD CONSTRAINT "D885be08a4a741c0553d7089a1be4853" FOREIGN KEY (product_id) REFERENCES vitashop_myproduct(product_ptr_id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: addressmodel_address_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY addressmodel_address
    ADD CONSTRAINT addressmodel_address_country_id_fkey FOREIGN KEY (country_id) REFERENCES addressmodel_country(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_content_type_id_508cf46651277a81_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_permission
    ADD CONSTRAINT auth_content_type_id_508cf46651277a81_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissio_group_id_689710a9a73b7457_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_group_id_689710a9a73b7457_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_group_permissions
    ADD CONSTRAINT auth_group_permission_id_1f49ccbbdc69d2fc_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user__permission_id_384b62483d7071f0_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user__permission_id_384b62483d7071f0_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_33ac548dcf5f8e37_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups_user_id_4b5ed4ffdb8fd9b0_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_4b5ed4ffdb8fd9b0_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permiss_user_id_7f0938558328534a_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permiss_user_id_7f0938558328534a_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: djan_content_type_id_697914295151027a_fk_django_content_type_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT djan_content_type_id_697914295151027a_fk_django_content_type_id FOREIGN KEY (content_type_id) REFERENCES django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log_user_id_52fdd58701c5f563_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_52fdd58701c5f563_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: fk_order_country; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_order
    ADD CONSTRAINT fk_order_country FOREIGN KEY (country_id) REFERENCES addressmodel_country(id);


--
-- Name: fk_social_auth_myuser; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY social_auth_usersocialauth
    ADD CONSTRAINT fk_social_auth_myuser FOREIGN KEY (user_id) REFERENCES vitashop_myuser(id);


--
-- Name: product_id_refs_id_fd98e281; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_cartitem
    ADD CONSTRAINT product_id_refs_id_fd98e281 FOREIGN KEY (product_id) REFERENCES shop_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shop_address_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_address
    ADD CONSTRAINT shop_address_country_id_fkey FOREIGN KEY (country_id) REFERENCES shop_country(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shop_cartitem_cart_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_cartitem
    ADD CONSTRAINT shop_cartitem_cart_id_fkey FOREIGN KEY (cart_id) REFERENCES shop_cart(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shop_extraorderitempricefield_order_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_extraorderitempricefield
    ADD CONSTRAINT shop_extraorderitempricefield_order_item_id_fkey FOREIGN KEY (order_item_id) REFERENCES shop_orderitem(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shop_extraorderpricefield_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_extraorderpricefield
    ADD CONSTRAINT shop_extraorderpricefield_order_id_fkey FOREIGN KEY (order_id) REFERENCES shop_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shop_orderextrainfo_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_orderextrainfo
    ADD CONSTRAINT shop_orderextrainfo_order_id_fkey FOREIGN KEY (order_id) REFERENCES shop_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shop_orderitem_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_orderitem
    ADD CONSTRAINT shop_orderitem_order_id_fkey FOREIGN KEY (order_id) REFERENCES shop_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shop_orderitem_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_orderitem
    ADD CONSTRAINT shop_orderitem_product_id_fkey FOREIGN KEY (product_id) REFERENCES shop_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: shop_orderpayment_order_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY shop_orderpayment
    ADD CONSTRAINT shop_orderpayment_order_id_fkey FOREIGN KEY (order_id) REFERENCES shop_order(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vi_orderpayment_ptr_id_13adc7edb8e8454d_fk_shop_orderpayment_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_paymenthistory
    ADD CONSTRAINT vi_orderpayment_ptr_id_13adc7edb8e8454d_fk_shop_orderpayment_id FOREIGN KEY (orderpayment_ptr_id) REFERENCES shop_orderpayment(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vitashop_cus_parent_id_19d64a1ed6c91c94_fk_vitashop_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_customer
    ADD CONSTRAINT vitashop_cus_parent_id_19d64a1ed6c91c94_fk_vitashop_customer_id FOREIGN KEY (parent_id) REFERENCES vitashop_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vitashop_custome_user_id_2858446cca0af12b_fk_vitashop_myuser_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_customer
    ADD CONSTRAINT vitashop_custome_user_id_2858446cca0af12b_fk_vitashop_myuser_id FOREIGN KEY (user_id) REFERENCES vitashop_myuser(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vitashop_m_category_id_756a75f41f8bed5c_fk_vitashop_category_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_myproduct
    ADD CONSTRAINT vitashop_m_category_id_756a75f41f8bed5c_fk_vitashop_category_id FOREIGN KEY (category_id) REFERENCES vitashop_category(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vitashop_m_permission_id_43d4d4dbb8a03260_fk_auth_permission_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_myuser_user_permissions
    ADD CONSTRAINT vitashop_m_permission_id_43d4d4dbb8a03260_fk_auth_permission_id FOREIGN KEY (permission_id) REFERENCES auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vitashop_myp_product_ptr_id_5ef8c1700e368d29_fk_shop_product_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_myproduct
    ADD CONSTRAINT vitashop_myp_product_ptr_id_5ef8c1700e368d29_fk_shop_product_id FOREIGN KEY (product_ptr_id) REFERENCES shop_product(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vitashop_myuse_myuser_id_59b99778b3896774_fk_vitashop_myuser_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_myuser_groups
    ADD CONSTRAINT vitashop_myuse_myuser_id_59b99778b3896774_fk_vitashop_myuser_id FOREIGN KEY (myuser_id) REFERENCES vitashop_myuser(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vitashop_myuse_myuser_id_7dbb1f366cbb149e_fk_vitashop_myuser_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_myuser_user_permissions
    ADD CONSTRAINT vitashop_myuse_myuser_id_7dbb1f366cbb149e_fk_vitashop_myuser_id FOREIGN KEY (myuser_id) REFERENCES vitashop_myuser(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vitashop_myuser_grou_group_id_1e408d555daf78b1_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_myuser_groups
    ADD CONSTRAINT vitashop_myuser_grou_group_id_1e408d555daf78b1_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: vitashop_s_customer_id_1bd655944caf6f91_fk_vitashop_customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY vitashop_shoppinghistory
    ADD CONSTRAINT vitashop_s_customer_id_1bd655944caf6f91_fk_vitashop_customer_id FOREIGN KEY (customer_id) REFERENCES vitashop_customer(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

