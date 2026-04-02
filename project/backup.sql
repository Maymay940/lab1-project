--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2026-02-26 13:46:35

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 245 (class 1255 OID 17330)
-- Name: calculate_consumption(); Type: FUNCTION; Schema: public; Owner: postgres2
--

CREATE FUNCTION public.calculate_consumption() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    last_reading INTEGER;
BEGIN
    -- Получаем последние подтвержденные показания счетчика
    SELECT last_verified_reading INTO last_reading
    FROM water_meters
    WHERE id = NEW.water_meter_id;
    
    -- Вычисляем расход
    NEW.consumption := NEW.current_reading - last_reading;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.calculate_consumption() OWNER TO postgres2;

--
-- TOC entry 246 (class 1255 OID 17332)
-- Name: calculate_request_totals(); Type: FUNCTION; Schema: public; Owner: postgres2
--

CREATE FUNCTION public.calculate_request_totals() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    total_cons INTEGER;
    total_amount DECIMAL(10,2);
    tariff_rate DECIMAL(10,2) := 50.00; -- 50 рублей за кубометр
BEGIN
    -- Суммируем расход по всем позициям
    SELECT SUM(consumption) INTO total_cons
    FROM reading_positions
    WHERE request_id = NEW.id;
    
    -- Рассчитываем сумму к оплате
    total_amount := COALESCE(total_cons, 0) * tariff_rate;
    
    -- Обновляем поля заявки
    NEW.total_consumption := COALESCE(total_cons, 0);
    NEW.amount_to_pay := total_amount;
    NEW.completed_at := CURRENT_TIMESTAMP;
    
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.calculate_request_totals() OWNER TO postgres2;

--
-- TOC entry 244 (class 1255 OID 17328)
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: postgres2
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO postgres2;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 232 (class 1259 OID 17415)
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres2;

--
-- TOC entry 231 (class 1259 OID 17414)
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_id_seq OWNER TO postgres2;

--
-- TOC entry 5106 (class 0 OID 0)
-- Dependencies: 231
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- TOC entry 234 (class 1259 OID 17424)
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres2;

--
-- TOC entry 233 (class 1259 OID 17423)
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_group_permissions_id_seq OWNER TO postgres2;

--
-- TOC entry 5107 (class 0 OID 0)
-- Dependencies: 233
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- TOC entry 230 (class 1259 OID 17401)
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres2;

--
-- TOC entry 229 (class 1259 OID 17400)
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_permission_id_seq OWNER TO postgres2;

--
-- TOC entry 5108 (class 0 OID 0)
-- Dependencies: 229
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- TOC entry 236 (class 1259 OID 17443)
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp without time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(150) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp without time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres2;

--
-- TOC entry 238 (class 1259 OID 17454)
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres2;

--
-- TOC entry 237 (class 1259 OID 17453)
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_groups_id_seq OWNER TO postgres2;

--
-- TOC entry 5109 (class 0 OID 0)
-- Dependencies: 237
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- TOC entry 235 (class 1259 OID 17442)
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_id_seq OWNER TO postgres2;

--
-- TOC entry 5110 (class 0 OID 0)
-- Dependencies: 235
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- TOC entry 240 (class 1259 OID 17473)
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres2;

--
-- TOC entry 239 (class 1259 OID 17472)
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNER TO postgres2;

--
-- TOC entry 5111 (class 0 OID 0)
-- Dependencies: 239
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- TOC entry 242 (class 1259 OID 17492)
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp without time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres2;

--
-- TOC entry 241 (class 1259 OID 17491)
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_admin_log_id_seq OWNER TO postgres2;

--
-- TOC entry 5112 (class 0 OID 0)
-- Dependencies: 241
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- TOC entry 228 (class 1259 OID 17392)
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres2;

--
-- TOC entry 227 (class 1259 OID 17391)
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.django_content_type_id_seq OWNER TO postgres2;

--
-- TOC entry 5113 (class 0 OID 0)
-- Dependencies: 227
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- TOC entry 224 (class 1259 OID 17335)
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.django_migrations (
    id bigint NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres2;

--
-- TOC entry 223 (class 1259 OID 17334)
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

ALTER TABLE public.django_migrations ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.django_migrations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 243 (class 1259 OID 17511)
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp without time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres2;

--
-- TOC entry 222 (class 1259 OID 17303)
-- Name: reading_positions; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.reading_positions (
    id integer NOT NULL,
    request_id integer NOT NULL,
    water_meter_id integer NOT NULL,
    current_reading integer NOT NULL,
    consumption integer NOT NULL,
    reading_photo_url text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_reading_positive CHECK ((current_reading >= 0))
);


ALTER TABLE public.reading_positions OWNER TO postgres2;

--
-- TOC entry 5114 (class 0 OID 0)
-- Dependencies: 222
-- Name: TABLE reading_positions; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON TABLE public.reading_positions IS 'Позиции заявки (переданные показания по конкретным счетчикам)';


--
-- TOC entry 5115 (class 0 OID 0)
-- Dependencies: 222
-- Name: COLUMN reading_positions.consumption; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON COLUMN public.reading_positions.consumption IS 'Расход = current_reading - last_verified_reading';


--
-- TOC entry 221 (class 1259 OID 17302)
-- Name: reading_positions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.reading_positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reading_positions_id_seq OWNER TO postgres2;

--
-- TOC entry 5116 (class 0 OID 0)
-- Dependencies: 221
-- Name: reading_positions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.reading_positions_id_seq OWNED BY public.reading_positions.id;


--
-- TOC entry 220 (class 1259 OID 17288)
-- Name: requests; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.requests (
    id integer NOT NULL,
    status character varying(20) DEFAULT 'draft'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    submitted_at timestamp without time zone,
    completed_at timestamp without time zone,
    total_consumption numeric(10,2),
    amount_to_pay numeric(10,2),
    comment text,
    user_id integer NOT NULL,
    CONSTRAINT check_dates CHECK ((((submitted_at IS NULL) OR (submitted_at >= created_at)) AND ((completed_at IS NULL) OR (completed_at >= submitted_at)))),
    CONSTRAINT valid_status CHECK (((status)::text = ANY ((ARRAY['draft'::character varying, 'submitted'::character varying, 'completed'::character varying, 'rejected'::character varying, 'deleted'::character varying])::text[])))
);


ALTER TABLE public.requests OWNER TO postgres2;

--
-- TOC entry 5117 (class 0 OID 0)
-- Dependencies: 220
-- Name: TABLE requests; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON TABLE public.requests IS 'Заявки на передачу показаний';


--
-- TOC entry 5118 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN requests.status; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON COLUMN public.requests.status IS 'draft-черновик, submitted-отправлено, completed-завершено, rejected-отклонено, deleted-удалено';


--
-- TOC entry 5119 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN requests.total_consumption; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON COLUMN public.requests.total_consumption IS 'Рассчитывается при завершении заявки';


--
-- TOC entry 5120 (class 0 OID 0)
-- Dependencies: 220
-- Name: COLUMN requests.amount_to_pay; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON COLUMN public.requests.amount_to_pay IS 'Рассчитывается при завершении заявки (50 руб/м³)';


--
-- TOC entry 219 (class 1259 OID 17287)
-- Name: requests_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.requests_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.requests_id_seq OWNER TO postgres2;

--
-- TOC entry 5121 (class 0 OID 0)
-- Dependencies: 219
-- Name: requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.requests_id_seq OWNED BY public.requests.id;


--
-- TOC entry 226 (class 1259 OID 17344)
-- Name: users; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    email character varying(255) NOT NULL,
    password_hash character varying(255) NOT NULL,
    first_name character varying(100),
    last_name character varying(100),
    phone character varying(20),
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO postgres2;

--
-- TOC entry 5122 (class 0 OID 0)
-- Dependencies: 226
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON TABLE public.users IS 'Пользователи системы';


--
-- TOC entry 225 (class 1259 OID 17343)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres2;

--
-- TOC entry 5123 (class 0 OID 0)
-- Dependencies: 225
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 218 (class 1259 OID 17266)
-- Name: water_meters; Type: TABLE; Schema: public; Owner: postgres2
--

CREATE TABLE public.water_meters (
    id integer NOT NULL,
    address character varying(255) NOT NULL,
    serial_number character varying(50) NOT NULL,
    meter_type character varying(10) NOT NULL,
    meter_model character varying(100) NOT NULL,
    installation_date date NOT NULL,
    initial_reading integer DEFAULT 0 NOT NULL,
    last_verified_reading integer DEFAULT 0 NOT NULL,
    last_reading_date date,
    next_verification_date date,
    photo_url text,
    setup_video_url text,
    is_active boolean DEFAULT true,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    user_id integer NOT NULL,
    CONSTRAINT check_readings CHECK ((last_verified_reading >= initial_reading)),
    CONSTRAINT water_meters_meter_type_check CHECK (((meter_type)::text = ANY ((ARRAY['HOT'::character varying, 'COLD'::character varying])::text[])))
);


ALTER TABLE public.water_meters OWNER TO postgres2;

--
-- TOC entry 5124 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE water_meters; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON TABLE public.water_meters IS 'Счетчики воды (услуги)';


--
-- TOC entry 5125 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN water_meters.meter_type; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON COLUMN public.water_meters.meter_type IS 'HOT - горячая вода, COLD - холодная вода';


--
-- TOC entry 5126 (class 0 OID 0)
-- Dependencies: 218
-- Name: COLUMN water_meters.last_verified_reading; Type: COMMENT; Schema: public; Owner: postgres2
--

COMMENT ON COLUMN public.water_meters.last_verified_reading IS 'Последние подтвержденные показания';


--
-- TOC entry 217 (class 1259 OID 17265)
-- Name: water_meters_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres2
--

CREATE SEQUENCE public.water_meters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.water_meters_id_seq OWNER TO postgres2;

--
-- TOC entry 5127 (class 0 OID 0)
-- Dependencies: 217
-- Name: water_meters_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres2
--

ALTER SEQUENCE public.water_meters_id_seq OWNED BY public.water_meters.id;


--
-- TOC entry 4825 (class 2604 OID 17418)
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- TOC entry 4826 (class 2604 OID 17427)
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- TOC entry 4824 (class 2604 OID 17404)
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- TOC entry 4827 (class 2604 OID 17446)
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- TOC entry 4828 (class 2604 OID 17457)
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- TOC entry 4829 (class 2604 OID 17476)
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- TOC entry 4830 (class 2604 OID 17495)
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- TOC entry 4823 (class 2604 OID 17395)
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- TOC entry 4818 (class 2604 OID 17306)
-- Name: reading_positions id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.reading_positions ALTER COLUMN id SET DEFAULT nextval('public.reading_positions_id_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 17291)
-- Name: requests id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.requests ALTER COLUMN id SET DEFAULT nextval('public.requests_id_seq'::regclass);


--
-- TOC entry 4820 (class 2604 OID 17347)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 17269)
-- Name: water_meters id; Type: DEFAULT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.water_meters ALTER COLUMN id SET DEFAULT nextval('public.water_meters_id_seq'::regclass);


--
-- TOC entry 5089 (class 0 OID 17415)
-- Dependencies: 232
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- TOC entry 5091 (class 0 OID 17424)
-- Dependencies: 234
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5087 (class 0 OID 17401)
-- Dependencies: 230
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	3	add_permission
6	Can change permission	3	change_permission
7	Can delete permission	3	delete_permission
8	Can view permission	3	view_permission
9	Can add group	2	add_group
10	Can change group	2	change_group
11	Can delete group	2	delete_group
12	Can view group	2	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add Пользователь	9	add_user
26	Can change Пользователь	9	change_user
27	Can delete Пользователь	9	delete_user
28	Can view Пользователь	9	view_user
29	Can add Заявка	8	add_request
30	Can change Заявка	8	change_request
31	Can delete Заявка	8	delete_request
32	Can view Заявка	8	view_request
33	Can add Счетчик	10	add_watermeter
34	Can change Счетчик	10	change_watermeter
35	Can delete Счетчик	10	delete_watermeter
36	Can view Счетчик	10	view_watermeter
37	Can add Позиция	7	add_readingposition
38	Can change Позиция	7	change_readingposition
39	Can delete Позиция	7	delete_readingposition
40	Can view Позиция	7	view_readingposition
\.


--
-- TOC entry 5093 (class 0 OID 17443)
-- Dependencies: 236
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
\.


--
-- TOC entry 5095 (class 0 OID 17454)
-- Dependencies: 238
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- TOC entry 5097 (class 0 OID 17473)
-- Dependencies: 240
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- TOC entry 5099 (class 0 OID 17492)
-- Dependencies: 242
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
\.


--
-- TOC entry 5085 (class 0 OID 17392)
-- Dependencies: 228
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	group
3	auth	permission
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	meters	readingposition
8	meters	request
9	meters	user
10	meters	watermeter
\.


--
-- TOC entry 5081 (class 0 OID 17335)
-- Dependencies: 224
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2026-02-22 11:31:25.650312+00
2	auth	0001_initial	2026-02-22 11:31:25.652937+00
3	admin	0001_initial	2026-02-22 11:31:25.653661+00
4	admin	0002_logentry_remove_auto_add	2026-02-22 11:31:25.654272+00
5	admin	0003_logentry_add_action_flag_choices	2026-02-22 11:31:25.654916+00
6	contenttypes	0002_remove_content_type_name	2026-02-22 11:31:25.655478+00
7	auth	0002_alter_permission_name_max_length	2026-02-22 11:31:25.656047+00
8	auth	0003_alter_user_email_max_length	2026-02-22 11:31:25.656635+00
9	auth	0004_alter_user_username_opts	2026-02-22 11:31:25.657214+00
10	auth	0005_alter_user_last_login_null	2026-02-22 11:31:25.65781+00
11	auth	0006_require_contenttypes_0002	2026-02-22 11:31:25.658432+00
12	auth	0007_alter_validators_add_error_messages	2026-02-22 11:31:25.659005+00
13	auth	0008_alter_user_username_max_length	2026-02-22 11:31:25.659588+00
14	auth	0009_alter_user_last_name_max_length	2026-02-22 11:31:25.660341+00
15	auth	0010_alter_group_name_max_length	2026-02-22 11:31:25.661364+00
16	auth	0011_update_proxy_permissions	2026-02-22 11:31:25.662139+00
17	auth	0012_alter_user_first_name_max_length	2026-02-22 11:31:25.662734+00
18	meters	0001_initial	2026-02-22 11:31:25.663307+00
19	sessions	0001_initial	2026-02-22 11:31:25.663867+00
\.


--
-- TOC entry 5100 (class 0 OID 17511)
-- Dependencies: 243
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
\.


--
-- TOC entry 5079 (class 0 OID 17303)
-- Dependencies: 222
-- Data for Name: reading_positions; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.reading_positions (id, request_id, water_meter_id, current_reading, consumption, reading_photo_url, created_at) FROM stdin;
12	6	2	2040	10	\N	2026-02-23 11:26:26.995632
13	7	2	2056	26	\N	2026-02-23 11:43:12.106299
14	7	3	3459	3	\N	2026-02-23 11:43:30.6773
15	8	3	3478	22	\N	2026-02-24 09:39:23.328539
16	9	3	3478	22	\N	2026-02-24 10:24:58.292276
17	10	3	3478	22	\N	2026-02-24 11:45:41.970137
18	11	2	2330	300	\N	2026-02-26 05:10:41.727649
\.


--
-- TOC entry 5077 (class 0 OID 17288)
-- Dependencies: 220
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.requests (id, status, created_at, submitted_at, completed_at, total_consumption, amount_to_pay, comment, user_id) FROM stdin;
7	submitted	2026-02-23 08:43:12.098507	2026-02-23 11:43:34.965699	\N	\N	\N		1
8	submitted	2026-02-24 06:39:23.308331	2026-02-24 09:39:32.266767	\N	\N	\N		1
9	submitted	2026-02-24 07:24:58.280375	2026-02-24 10:25:02.477224	\N	\N	\N		1
10	submitted	2026-02-24 08:45:41.963523	2026-02-26 05:09:53.380263	\N	\N	\N		1
11	submitted	2026-02-26 02:10:41.71623	2026-02-26 05:10:43.315414	\N	\N	\N		1
12	draft	2026-02-26 05:26:32.856918	\N	\N	\N	\N		1
6	completed	2026-02-23 08:26:26.987434	2026-02-23 11:26:33.819298	2026-02-26 05:35:53.645478	10.00	500.00		1
\.


--
-- TOC entry 5083 (class 0 OID 17344)
-- Dependencies: 226
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.users (id, username, email, password_hash, first_name, last_name, phone, is_active, created_at) FROM stdin;
1	ivanov	ivanov@email.com	hash123	Иван	Иванов	+7(999)123-45-67	t	2026-02-25 03:15:50.425051
2	petrov	petrov@email.com	hash456	Петр	Петров	+7(999)234-56-78	t	2026-02-25 03:15:50.425051
3	sidorova	sidorova@email.com	hash789	Анна	Сидорова	+7(999)345-67-89	t	2026-02-25 03:15:50.425051
4	moderator	moderator@uk.ru	hash000	Модератор	УК	+7(999)999-99-99	t	2026-02-25 03:15:50.425051
\.


--
-- TOC entry 5075 (class 0 OID 17266)
-- Dependencies: 218
-- Data for Name: water_meters; Type: TABLE DATA; Schema: public; Owner: postgres2
--

COPY public.water_meters (id, address, serial_number, meter_type, meter_model, installation_date, initial_reading, last_verified_reading, last_reading_date, next_verification_date, photo_url, setup_video_url, is_active, created_at, updated_at, user_id) FROM stdin;
3	ул. Победы, д. 22, кв. 7	5258402	COLD	ДУ-32	2022-05-20	0	3456	2025-02-08	2028-05-20	http://localhost:9000/meters/imagers/photo3.png	\N	t	2026-02-22 10:43:10.784879	2026-02-25 03:16:07.310726	2
4	ул. Победы, д. 22, кв. 7	5312913	HOT	ДУ-32	2022-05-20	0	2150	2025-02-08	2028-05-20	http://localhost:9000/meters/imagers/photo4.png	\N	t	2026-02-22 10:43:10.784879	2026-02-25 03:16:07.310726	2
6	ул. Советская, д. 3, кв. 89	0008391	COLD	Х1	2024-02-01	0	380	2025-02-12	2030-02-01	http://localhost:9000/meters/imagers/photo6.png	\N	t	2026-02-22 10:43:10.784879	2026-02-25 03:16:07.310726	3
7	ул. Лесная, д. 12, кв. 23	14-272442	COLD	WFK2	2023-11-10	500	890	2025-02-01	2029-11-10	http://localhost:9000/meters/imagers/photo7.png	\N	t	2026-02-22 10:43:10.784879	2026-02-25 03:16:07.310726	3
8	ул. Садовая, д. 4, кв. 45	14-283074	HOT	WFW2	2023-11-10	600	920	2025-02-01	2029-11-10	http://localhost:9000/meters/imagers/photo8.png	\N	t	2026-02-22 10:43:10.784879	2026-02-25 03:16:07.310726	3
2	ул. Пушкина, д. 10, кв. 5	0014443	COLD	СХВ-13	2023-01-15	50	2030	2025-02-10	2029-01-15	http://localhost:9000/meters/imagers/photo2.png	\N	t	2026-02-22 10:43:10.784879	2026-02-25 09:36:25.59596	1
5	ул. Советская, д. 3, кв. 89	0008397	HOT	Г1	2024-02-01	0	450	2025-02-12	2030-02-01	http://localhost:9000/meters/imagers/photo5.png	\N	t	2026-02-22 10:43:10.784879	2026-02-25 09:36:25.59596	3
1	ул. Пушкина, д. 10, кв. 5	30069237	HOT	СГВ-15	2023-01-15	100	1250	2025-02-10	2029-01-15	http://localhost:9000/meters/imagers/photo1.jpeg	http://localhost:9000/meters/video/video_water.mp4	t	2026-02-22 10:43:10.784879	2026-02-25 09:37:23.896091	1
\.


--
-- TOC entry 5128 (class 0 OID 0)
-- Dependencies: 231
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- TOC entry 5129 (class 0 OID 0)
-- Dependencies: 233
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 5130 (class 0 OID 0)
-- Dependencies: 229
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 40, true);


--
-- TOC entry 5131 (class 0 OID 0)
-- Dependencies: 237
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- TOC entry 5132 (class 0 OID 0)
-- Dependencies: 235
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- TOC entry 5133 (class 0 OID 0)
-- Dependencies: 239
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 5134 (class 0 OID 0)
-- Dependencies: 241
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- TOC entry 5135 (class 0 OID 0)
-- Dependencies: 227
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 10, true);


--
-- TOC entry 5136 (class 0 OID 0)
-- Dependencies: 223
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 19, true);


--
-- TOC entry 5137 (class 0 OID 0)
-- Dependencies: 221
-- Name: reading_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.reading_positions_id_seq', 18, true);


--
-- TOC entry 5138 (class 0 OID 0)
-- Dependencies: 219
-- Name: requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.requests_id_seq', 12, true);


--
-- TOC entry 5139 (class 0 OID 0)
-- Dependencies: 225
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- TOC entry 5140 (class 0 OID 0)
-- Dependencies: 217
-- Name: water_meters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.water_meters_id_seq', 8, true);


--
-- TOC entry 4881 (class 2606 OID 17422)
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- TOC entry 4886 (class 2606 OID 17431)
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_uniq UNIQUE (group_id, permission_id);


--
-- TOC entry 4889 (class 2606 OID 17429)
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4883 (class 2606 OID 17420)
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- TOC entry 4876 (class 2606 OID 17408)
-- Name: auth_permission auth_permission_content_type_id_codename_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_uniq UNIQUE (content_type_id, codename);


--
-- TOC entry 4879 (class 2606 OID 17406)
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- TOC entry 4896 (class 2606 OID 17459)
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- TOC entry 4898 (class 2606 OID 17461)
-- Name: auth_user_groups auth_user_groups_user_id_group_id_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_uniq UNIQUE (user_id, group_id);


--
-- TOC entry 4891 (class 2606 OID 17450)
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- TOC entry 4902 (class 2606 OID 17478)
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4905 (class 2606 OID 17480)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_uniq UNIQUE (user_id, permission_id);


--
-- TOC entry 4893 (class 2606 OID 17452)
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- TOC entry 4908 (class 2606 OID 17500)
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- TOC entry 4872 (class 2606 OID 17399)
-- Name: django_content_type django_content_type_app_label_model_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_uniq UNIQUE (app_label, model);


--
-- TOC entry 4874 (class 2606 OID 17397)
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4860 (class 2606 OID 17341)
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 4912 (class 2606 OID 17517)
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- TOC entry 4856 (class 2606 OID 17312)
-- Name: reading_positions reading_positions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.reading_positions
    ADD CONSTRAINT reading_positions_pkey PRIMARY KEY (id);


--
-- TOC entry 4851 (class 2606 OID 17299)
-- Name: requests requests_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_pkey PRIMARY KEY (id);


--
-- TOC entry 4858 (class 2606 OID 17314)
-- Name: reading_positions unique_request_meter; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.reading_positions
    ADD CONSTRAINT unique_request_meter UNIQUE (request_id, water_meter_id);


--
-- TOC entry 4865 (class 2606 OID 17358)
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- TOC entry 4867 (class 2606 OID 17354)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4869 (class 2606 OID 17356)
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- TOC entry 4843 (class 2606 OID 17280)
-- Name: water_meters water_meters_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.water_meters
    ADD CONSTRAINT water_meters_pkey PRIMARY KEY (id);


--
-- TOC entry 4845 (class 2606 OID 17282)
-- Name: water_meters water_meters_serial_number_key; Type: CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.water_meters
    ADD CONSTRAINT water_meters_serial_number_key UNIQUE (serial_number);


--
-- TOC entry 4884 (class 1259 OID 17520)
-- Name: auth_group_permissions_group_id_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX auth_group_permissions_group_id_idx ON public.auth_group_permissions USING btree (group_id);


--
-- TOC entry 4887 (class 1259 OID 17521)
-- Name: auth_group_permissions_permission_id_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX auth_group_permissions_permission_id_idx ON public.auth_group_permissions USING btree (permission_id);


--
-- TOC entry 4877 (class 1259 OID 17519)
-- Name: auth_permission_content_type_id_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX auth_permission_content_type_id_idx ON public.auth_permission USING btree (content_type_id);


--
-- TOC entry 4894 (class 1259 OID 17523)
-- Name: auth_user_groups_group_id_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX auth_user_groups_group_id_idx ON public.auth_user_groups USING btree (group_id);


--
-- TOC entry 4899 (class 1259 OID 17522)
-- Name: auth_user_groups_user_id_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX auth_user_groups_user_id_idx ON public.auth_user_groups USING btree (user_id);


--
-- TOC entry 4900 (class 1259 OID 17525)
-- Name: auth_user_user_permissions_permission_id_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX auth_user_user_permissions_permission_id_idx ON public.auth_user_user_permissions USING btree (permission_id);


--
-- TOC entry 4903 (class 1259 OID 17524)
-- Name: auth_user_user_permissions_user_id_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX auth_user_user_permissions_user_id_idx ON public.auth_user_user_permissions USING btree (user_id);


--
-- TOC entry 4906 (class 1259 OID 17526)
-- Name: django_admin_log_content_type_id_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX django_admin_log_content_type_id_idx ON public.django_admin_log USING btree (content_type_id);


--
-- TOC entry 4909 (class 1259 OID 17527)
-- Name: django_admin_log_user_id_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX django_admin_log_user_id_idx ON public.django_admin_log USING btree (user_id);


--
-- TOC entry 4870 (class 1259 OID 17518)
-- Name: django_content_type_app_label_model_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX django_content_type_app_label_model_idx ON public.django_content_type USING btree (app_label, model);


--
-- TOC entry 4910 (class 1259 OID 17528)
-- Name: django_session_expire_date_idx; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX django_session_expire_date_idx ON public.django_session USING btree (expire_date);


--
-- TOC entry 4852 (class 1259 OID 17326)
-- Name: idx_reading_positions_meter_id; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_reading_positions_meter_id ON public.reading_positions USING btree (water_meter_id);


--
-- TOC entry 4853 (class 1259 OID 17325)
-- Name: idx_reading_positions_request_id; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_reading_positions_request_id ON public.reading_positions USING btree (request_id);


--
-- TOC entry 4854 (class 1259 OID 17327)
-- Name: idx_reading_positions_request_meter; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_reading_positions_request_meter ON public.reading_positions USING btree (request_id, water_meter_id);


--
-- TOC entry 4846 (class 1259 OID 17301)
-- Name: idx_requests_created_at; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_requests_created_at ON public.requests USING btree (created_at DESC);


--
-- TOC entry 4847 (class 1259 OID 17300)
-- Name: idx_requests_status; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_requests_status ON public.requests USING btree (status);


--
-- TOC entry 4848 (class 1259 OID 17388)
-- Name: idx_requests_user_id; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_requests_user_id ON public.requests USING btree (user_id);


--
-- TOC entry 4849 (class 1259 OID 17390)
-- Name: idx_unique_user_draft; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE UNIQUE INDEX idx_unique_user_draft ON public.requests USING btree (user_id) WHERE ((status)::text = 'draft'::text);


--
-- TOC entry 4861 (class 1259 OID 17360)
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- TOC entry 4862 (class 1259 OID 17361)
-- Name: idx_users_is_active; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_users_is_active ON public.users USING btree (is_active) WHERE (is_active = true);


--
-- TOC entry 4863 (class 1259 OID 17359)
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- TOC entry 4837 (class 1259 OID 17284)
-- Name: idx_water_meters_address; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_water_meters_address ON public.water_meters USING btree (address);


--
-- TOC entry 4838 (class 1259 OID 17286)
-- Name: idx_water_meters_is_active; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_water_meters_is_active ON public.water_meters USING btree (is_active) WHERE (is_active = true);


--
-- TOC entry 4839 (class 1259 OID 17283)
-- Name: idx_water_meters_serial; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_water_meters_serial ON public.water_meters USING btree (serial_number);


--
-- TOC entry 4840 (class 1259 OID 17285)
-- Name: idx_water_meters_type; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_water_meters_type ON public.water_meters USING btree (meter_type);


--
-- TOC entry 4841 (class 1259 OID 17367)
-- Name: idx_water_meters_user_id; Type: INDEX; Schema: public; Owner: postgres2
--

CREATE INDEX idx_water_meters_user_id ON public.water_meters USING btree (user_id);


--
-- TOC entry 4928 (class 2620 OID 17342)
-- Name: reading_positions trigger_calculate_consumption; Type: TRIGGER; Schema: public; Owner: postgres2
--

CREATE TRIGGER trigger_calculate_consumption BEFORE INSERT ON public.reading_positions FOR EACH ROW EXECUTE FUNCTION public.calculate_consumption();


--
-- TOC entry 4927 (class 2620 OID 17333)
-- Name: requests trigger_calculate_request_totals; Type: TRIGGER; Schema: public; Owner: postgres2
--

CREATE TRIGGER trigger_calculate_request_totals BEFORE UPDATE ON public.requests FOR EACH ROW WHEN ((((new.status)::text = 'completed'::text) AND ((old.status)::text <> 'completed'::text))) EXECUTE FUNCTION public.calculate_request_totals();


--
-- TOC entry 4926 (class 2620 OID 17329)
-- Name: water_meters trigger_update_water_meters_timestamp; Type: TRIGGER; Schema: public; Owner: postgres2
--

CREATE TRIGGER trigger_update_water_meters_timestamp BEFORE UPDATE ON public.water_meters FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- TOC entry 4918 (class 2606 OID 17432)
-- Name: auth_group_permissions auth_group_permissions_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.auth_group(id) ON DELETE CASCADE;


--
-- TOC entry 4919 (class 2606 OID 17437)
-- Name: auth_group_permissions auth_group_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) ON DELETE CASCADE;


--
-- TOC entry 4917 (class 2606 OID 17409)
-- Name: auth_permission auth_permission_content_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_fkey FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) ON DELETE CASCADE;


--
-- TOC entry 4920 (class 2606 OID 17467)
-- Name: auth_user_groups auth_user_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.auth_group(id) ON DELETE CASCADE;


--
-- TOC entry 4921 (class 2606 OID 17462)
-- Name: auth_user_groups auth_user_groups_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON DELETE CASCADE;


--
-- TOC entry 4922 (class 2606 OID 17486)
-- Name: auth_user_user_permissions auth_user_user_permissions_permission_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_permission_id_fkey FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) ON DELETE CASCADE;


--
-- TOC entry 4923 (class 2606 OID 17481)
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON DELETE CASCADE;


--
-- TOC entry 4924 (class 2606 OID 17501)
-- Name: django_admin_log django_admin_log_content_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_fkey FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) ON DELETE CASCADE;


--
-- TOC entry 4925 (class 2606 OID 17506)
-- Name: django_admin_log django_admin_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.auth_user(id) ON DELETE CASCADE;


--
-- TOC entry 4915 (class 2606 OID 17315)
-- Name: reading_positions reading_positions_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.reading_positions
    ADD CONSTRAINT reading_positions_request_id_fkey FOREIGN KEY (request_id) REFERENCES public.requests(id) ON DELETE RESTRICT;


--
-- TOC entry 4916 (class 2606 OID 17320)
-- Name: reading_positions reading_positions_water_meter_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.reading_positions
    ADD CONSTRAINT reading_positions_water_meter_id_fkey FOREIGN KEY (water_meter_id) REFERENCES public.water_meters(id) ON DELETE RESTRICT;


--
-- TOC entry 4914 (class 2606 OID 17378)
-- Name: requests requests_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.requests
    ADD CONSTRAINT requests_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


--
-- TOC entry 4913 (class 2606 OID 17362)
-- Name: water_meters water_meters_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres2
--

ALTER TABLE ONLY public.water_meters
    ADD CONSTRAINT water_meters_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE RESTRICT;


-- Completed on 2026-02-26 13:46:36

--
-- PostgreSQL database dump complete
--

