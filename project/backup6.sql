--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.4

-- Started on 2026-02-27 18:33:29

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
-- TOC entry 5050 (class 0 OID 17415)
-- Dependencies: 226
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5046 (class 0 OID 17392)
-- Dependencies: 222
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres2
--

INSERT INTO public.django_content_type (id, app_label, model) VALUES (1, 'admin', 'logentry');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (2, 'auth', 'group');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (3, 'auth', 'permission');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (4, 'auth', 'user');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (5, 'contenttypes', 'contenttype');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (6, 'sessions', 'session');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (7, 'meters', 'readingposition');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (8, 'meters', 'request');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (9, 'meters', 'user');
INSERT INTO public.django_content_type (id, app_label, model) VALUES (10, 'meters', 'watermeter');


--
-- TOC entry 5048 (class 0 OID 17401)
-- Dependencies: 224
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres2
--

INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (5, 'Can add permission', 3, 'add_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (6, 'Can change permission', 3, 'change_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (7, 'Can delete permission', 3, 'delete_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (8, 'Can view permission', 3, 'view_permission');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (9, 'Can add group', 2, 'add_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (10, 'Can change group', 2, 'change_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (11, 'Can delete group', 2, 'delete_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (12, 'Can view group', 2, 'view_group');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (13, 'Can add user', 4, 'add_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (14, 'Can change user', 4, 'change_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (15, 'Can delete user', 4, 'delete_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (16, 'Can view user', 4, 'view_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (17, 'Can add content type', 5, 'add_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (18, 'Can change content type', 5, 'change_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (19, 'Can delete content type', 5, 'delete_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (20, 'Can view content type', 5, 'view_contenttype');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (21, 'Can add session', 6, 'add_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (22, 'Can change session', 6, 'change_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (23, 'Can delete session', 6, 'delete_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (24, 'Can view session', 6, 'view_session');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (25, 'Can add Пользователь', 9, 'add_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (26, 'Can change Пользователь', 9, 'change_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (27, 'Can delete Пользователь', 9, 'delete_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (28, 'Can view Пользователь', 9, 'view_user');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (29, 'Can add Заявка', 8, 'add_request');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (30, 'Can change Заявка', 8, 'change_request');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (31, 'Can delete Заявка', 8, 'delete_request');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (32, 'Can view Заявка', 8, 'view_request');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (33, 'Can add Счетчик', 10, 'add_watermeter');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (34, 'Can change Счетчик', 10, 'change_watermeter');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (35, 'Can delete Счетчик', 10, 'delete_watermeter');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (36, 'Can view Счетчик', 10, 'view_watermeter');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (37, 'Can add Позиция', 7, 'add_readingposition');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (38, 'Can change Позиция', 7, 'change_readingposition');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (39, 'Can delete Позиция', 7, 'delete_readingposition');
INSERT INTO public.auth_permission (id, name, content_type_id, codename) VALUES (40, 'Can view Позиция', 7, 'view_readingposition');


--
-- TOC entry 5052 (class 0 OID 17424)
-- Dependencies: 228
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5054 (class 0 OID 17443)
-- Dependencies: 230
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5056 (class 0 OID 17454)
-- Dependencies: 232
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5058 (class 0 OID 17473)
-- Dependencies: 234
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5060 (class 0 OID 17492)
-- Dependencies: 236
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5042 (class 0 OID 17335)
-- Dependencies: 218
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres2
--

INSERT INTO public.django_migrations (id, app, name, applied) VALUES (1, 'contenttypes', '0001_initial', '2026-02-22 11:31:25.650312+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (2, 'auth', '0001_initial', '2026-02-22 11:31:25.652937+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (3, 'admin', '0001_initial', '2026-02-22 11:31:25.653661+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (4, 'admin', '0002_logentry_remove_auto_add', '2026-02-22 11:31:25.654272+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (5, 'admin', '0003_logentry_add_action_flag_choices', '2026-02-22 11:31:25.654916+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (6, 'contenttypes', '0002_remove_content_type_name', '2026-02-22 11:31:25.655478+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (7, 'auth', '0002_alter_permission_name_max_length', '2026-02-22 11:31:25.656047+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (8, 'auth', '0003_alter_user_email_max_length', '2026-02-22 11:31:25.656635+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (9, 'auth', '0004_alter_user_username_opts', '2026-02-22 11:31:25.657214+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (10, 'auth', '0005_alter_user_last_login_null', '2026-02-22 11:31:25.65781+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (11, 'auth', '0006_require_contenttypes_0002', '2026-02-22 11:31:25.658432+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (12, 'auth', '0007_alter_validators_add_error_messages', '2026-02-22 11:31:25.659005+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (13, 'auth', '0008_alter_user_username_max_length', '2026-02-22 11:31:25.659588+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (14, 'auth', '0009_alter_user_last_name_max_length', '2026-02-22 11:31:25.660341+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (15, 'auth', '0010_alter_group_name_max_length', '2026-02-22 11:31:25.661364+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (16, 'auth', '0011_update_proxy_permissions', '2026-02-22 11:31:25.662139+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (17, 'auth', '0012_alter_user_first_name_max_length', '2026-02-22 11:31:25.662734+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (19, 'sessions', '0001_initial', '2026-02-22 11:31:25.663867+00');
INSERT INTO public.django_migrations (id, app, name, applied) VALUES (22, 'meters', '0001_initial', '2026-02-27 11:08:06.891672+00');


--
-- TOC entry 5061 (class 0 OID 17511)
-- Dependencies: 237
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5044 (class 0 OID 17344)
-- Dependencies: 220
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres2
--

INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, phone, is_active, created_at) VALUES (1, 'ivanov', 'ivanov@email.com', 'hash123', 'Иван', 'Иванов', '+7(999)123-45-67', true, '2026-02-25 03:15:50.425051');
INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, phone, is_active, created_at) VALUES (2, 'petrov', 'petrov@email.com', 'hash456', 'Петр', 'Петров', '+7(999)234-56-78', true, '2026-02-25 03:15:50.425051');
INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, phone, is_active, created_at) VALUES (3, 'sidorova', 'sidorova@email.com', 'hash789', 'Анна', 'Сидорова', '+7(999)345-67-89', true, '2026-02-25 03:15:50.425051');
INSERT INTO public.users (id, username, email, password_hash, first_name, last_name, phone, is_active, created_at) VALUES (4, 'moderator', 'moderator@uk.ru', 'hash000', 'Модератор', 'УК', '+7(999)999-99-99', true, '2026-02-25 03:15:50.425051');


--
-- TOC entry 5063 (class 0 OID 17644)
-- Dependencies: 239
-- Data for Name: requests; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5065 (class 0 OID 17652)
-- Dependencies: 241
-- Data for Name: water_meters; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5067 (class 0 OID 17662)
-- Dependencies: 243
-- Data for Name: reading_positions; Type: TABLE DATA; Schema: public; Owner: postgres2
--



--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 225
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 227
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 223
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 40, true);


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 231
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 229
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, false);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 233
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 235
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, false);


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 221
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 10, true);


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 217
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 22, true);


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 242
-- Name: reading_positions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.reading_positions_id_seq', 1, false);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 238
-- Name: requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.requests_id_seq', 1, false);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 219
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.users_id_seq', 4, true);


--
-- TOC entry 5085 (class 0 OID 0)
-- Dependencies: 240
-- Name: water_meters_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres2
--

SELECT pg_catalog.setval('public.water_meters_id_seq', 1, false);


-- Completed on 2026-02-27 18:33:29

--
-- PostgreSQL database dump complete
--

