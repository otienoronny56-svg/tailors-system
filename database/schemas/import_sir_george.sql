-- MIGRATION SCRIPT FOR SIR GEORGE SUITS

DO $$
DECLARE
  v_org_id uuid := gen_random_uuid();
  v_shop_id uuid := gen_random_uuid();
  v_manager_id uuid;
  v_worker_18 uuid := gen_random_uuid();
  v_worker_19 uuid := gen_random_uuid();
  v_worker_20 uuid := gen_random_uuid();
  v_worker_21 uuid := gen_random_uuid();
  v_worker_22 uuid := gen_random_uuid();
  v_worker_23 uuid := gen_random_uuid();
  v_worker_24 uuid := gen_random_uuid();
  v_worker_26 uuid := gen_random_uuid();
  v_worker_27 uuid := gen_random_uuid();
  v_worker_28 uuid := gen_random_uuid();
  v_worker_29 uuid := gen_random_uuid();
  v_worker_30 uuid := gen_random_uuid();
  v_worker_31 uuid := gen_random_uuid();
  v_client_014d8e64_82ba_4fb6_a6c4_8fed1e82d7bc uuid := gen_random_uuid();
  v_client_0d93f7af_13e6_4c2e_b774_90d351c9c956 uuid := gen_random_uuid();
  v_client_13bdd14e_e394_434f_a4e9_73cbf0a59250 uuid := gen_random_uuid();
  v_client_19280812_d033_4be2_8f99_82541c0adcb9 uuid := gen_random_uuid();
  v_client_1a2fcd38_6e5a_40d9_b74b_1e5795147c53 uuid := gen_random_uuid();
  v_client_29e57704_f083_41d4_aabb_f949c12b1f15 uuid := gen_random_uuid();
  v_client_39a9f07b_7b7f_4e99_9c8f_931fa3c00630 uuid := gen_random_uuid();
  v_client_492da2a1_90d9_48d7_9fec_86a46d8280e0 uuid := gen_random_uuid();
  v_client_52834b02_ccc6_4f0c_ac9d_df3a680c5b18 uuid := gen_random_uuid();
  v_client_5369681a_1710_4e0f_a6f8_7f00420a61d7 uuid := gen_random_uuid();
  v_client_54904eb1_e956_4b83_8bfa_51dcb0ec9e27 uuid := gen_random_uuid();
  v_client_676d040a_1a90_401d_8031_2c869374bd29 uuid := gen_random_uuid();
  v_client_6847c431_ab9b_4a2e_abc2_71b1f2f808f8 uuid := gen_random_uuid();
  v_client_6932cf9e_9d84_4019_ab17_cdc0d703b18d uuid := gen_random_uuid();
  v_client_707cfec1_74ac_4e0c_8c83_6e69468a091d uuid := gen_random_uuid();
  v_client_70aabf51_2941_44ef_872e_be9bc18e81ce uuid := gen_random_uuid();
  v_client_7722c9f5_ecfa_43d2_913e_4c7bed8aa07b uuid := gen_random_uuid();
  v_client_9086d37a_8728_4782_957d_28b111f31da3 uuid := gen_random_uuid();
  v_client_a0464ccc_dbf8_42e2_b07c_2a0f01921a73 uuid := gen_random_uuid();
  v_client_c7ae6e79_353b_4e8f_b4dc_8994c6caa57d uuid := gen_random_uuid();
  v_client_cc0fb17f_e2ee_41d7_9169_9d42cdc7583a uuid := gen_random_uuid();
  v_client_d1113880_3bac_4423_8654_dff214edbbd9 uuid := gen_random_uuid();
  v_client_e48883e9_6435_44dd_86b3_677ebbca223f uuid := gen_random_uuid();
  v_client_e8207ed0_2bdd_40f2_b133_e7354b6595bd uuid := gen_random_uuid();
  v_client_e9133905_2d99_4fe9_8de3_c5d29b7bc1d2 uuid := gen_random_uuid();
  v_client_ee57260a_457d_4ed1_a34c_a8783b797c94 uuid := gen_random_uuid();
  v_order_23 uuid := gen_random_uuid();
  v_order_24 uuid := gen_random_uuid();
  v_order_25 uuid := gen_random_uuid();
  v_order_26 uuid := gen_random_uuid();
  v_order_27 uuid := gen_random_uuid();
  v_order_28 uuid := gen_random_uuid();
  v_order_30 uuid := gen_random_uuid();
  v_order_31 uuid := gen_random_uuid();
  v_order_32 uuid := gen_random_uuid();
  v_order_33 uuid := gen_random_uuid();
  v_order_34 uuid := gen_random_uuid();
  v_order_36 uuid := gen_random_uuid();
  v_order_37 uuid := gen_random_uuid();
  v_order_39 uuid := gen_random_uuid();
  v_order_40 uuid := gen_random_uuid();
  v_order_41 uuid := gen_random_uuid();
  v_order_42 uuid := gen_random_uuid();
  v_order_43 uuid := gen_random_uuid();
  v_order_44 uuid := gen_random_uuid();
  v_order_45 uuid := gen_random_uuid();
  v_order_46 uuid := gen_random_uuid();
  v_order_47 uuid := gen_random_uuid();
  v_order_48 uuid := gen_random_uuid();
  v_order_49 uuid := gen_random_uuid();
  v_order_50 uuid := gen_random_uuid();
  v_order_51 uuid := gen_random_uuid();
  v_order_52 uuid := gen_random_uuid();
  v_order_53 uuid := gen_random_uuid();
  v_order_58 uuid := gen_random_uuid();
  v_order_59 uuid := gen_random_uuid();
  v_order_60 uuid := gen_random_uuid();
  v_order_61 uuid := gen_random_uuid();
  v_order_62 uuid := gen_random_uuid();
  v_order_63 uuid := gen_random_uuid();
  v_order_64 uuid := gen_random_uuid();
  v_order_65 uuid := gen_random_uuid();
  v_order_66 uuid := gen_random_uuid();
  v_order_67 uuid := gen_random_uuid();
  v_order_68 uuid := gen_random_uuid();
  v_order_69 uuid := gen_random_uuid();
  v_order_70 uuid := gen_random_uuid();
  v_order_71 uuid := gen_random_uuid();
  v_order_72 uuid := gen_random_uuid();
  v_order_73 uuid := gen_random_uuid();
  v_order_74 uuid := gen_random_uuid();
  v_order_75 uuid := gen_random_uuid();
  v_order_76 uuid := gen_random_uuid();
  v_order_77 uuid := gen_random_uuid();
  v_order_78 uuid := gen_random_uuid();
  v_order_80 uuid := gen_random_uuid();
  v_order_81 uuid := gen_random_uuid();
  v_order_82 uuid := gen_random_uuid();
  v_order_83 uuid := gen_random_uuid();
  v_order_84 uuid := gen_random_uuid();
  v_order_85 uuid := gen_random_uuid();
  v_order_86 uuid := gen_random_uuid();
  v_order_87 uuid := gen_random_uuid();
  v_order_88 uuid := gen_random_uuid();
  v_order_89 uuid := gen_random_uuid();
  v_order_90 uuid := gen_random_uuid();
BEGIN

-- 1. Find the User in Auth (They just tried to register!)
SELECT id INTO v_manager_id FROM auth.users WHERE email = 'sirgeorgesuits@gmail.com' LIMIT 1;
IF v_manager_id IS NULL THEN
  RAISE EXCEPTION 'User sirgeorgesuits@gmail.com not found in auth.users. Please sign up first!';
END IF;

-- 2. Create Organization & Shop
INSERT INTO public.organizations (id, name) VALUES (v_org_id, 'Sir George Suits');
INSERT INTO public.shops (id, organization_id, name) VALUES (v_shop_id, v_org_id, 'Sir George Suits');

-- 3. Link User Profile
INSERT INTO public.user_profiles (id, organization_id, shop_id, full_name, role, email, status) 
VALUES (v_manager_id, v_org_id, v_shop_id, 'David Gichuru', 'owner', 'sirgeorgesuits@gmail.com', 'Active')
ON CONFLICT (id) DO UPDATE SET organization_id = EXCLUDED.organization_id, shop_id = EXCLUDED.shop_id, role = 'owner', status = 'Active';

-- 4. Import Workers
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_18, v_org_id, v_shop_id, 'Esther', 'tailor', '0793981798');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_19, v_org_id, v_shop_id, 'Ochieng', 'tailor', '0714348004');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_20, v_org_id, v_shop_id, 'Ochi Ladies', 'tailor', '0715964600');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_21, v_org_id, v_shop_id, 'Wilson', 'tailor', '0722243556');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_22, v_org_id, v_shop_id, 'Silas', 'tailor', '0720802840');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_23, v_org_id, v_shop_id, 'Dickson', 'tailor', '0791078611');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_24, v_org_id, v_shop_id, 'Paul Olwa', 'tailor', '0723788499');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_26, v_org_id, v_shop_id, 'test worker', 'tailor', '07898765546');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_27, v_org_id, v_shop_id, 'worker 2', 'tailor', '0789675466');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_28, v_org_id, v_shop_id, 'worker 3', 'tailor', '12987373377');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_29, v_org_id, v_shop_id, 'worker 4', 'tailor', '09876867788');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_30, v_org_id, v_shop_id, 'Awasi', 'tailor', '0725205305');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number) 
VALUES (v_worker_31, v_org_id, v_shop_id, 'Bonface', 'tailor', '0797449656');

-- 5. Import Clients
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_014d8e64_82ba_4fb6_a6c4_8fed1e82d7bc, v_org_id, 'Mr Simon Kipruto', '0728263487', '[{"date": "2025-12-15T16:16:40.929+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":18,\"Chest\":40,\"Waist\":38,\"Bicep\":14.5,\"Sleeve\":24,\"Length\":29},\"Shirt\":{},\"Trouser\":{\"Waist\":36.5,\"Thigh\":28,\"Knee\":18.5,\"Bottom\":15.5,\"Length\":41.5,\"Crotch\":28.5}}"}]'::jsonb, 'Suit', 'Blue senator suit.
2068#2');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_0d93f7af_13e6_4c2e_b774_90d351c9c956, v_org_id, 'Earnest Kimitei', '0722757079  ', '[{"date": "2025-12-09T08:23:10.202+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":19,\"Chest\":46,\"Waist\":44.5,\"Bicep\":15,\"Sleeve\":9.5,\"Length\":32},\"Shirt\":{\"Neck\":17.5},\"Trouser\":{\"Waist\":42,\"Thigh\":28,\"Knee\":19,\"Bottom\":15.5,\"Length\":41,\"Crotch\":29}}"}]'::jsonb, 'Suit', 'Kaunda
Rinear 3#12
Short sleeve 4 pockets
2nd kaunda
4 pockets short sleeve
R6#PB30');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_13bdd14e_e394_434f_a4e9_73cbf0a59250, v_org_id, 'Bishop Kepha Omae', '0722743515', '[{"date": "2026-01-06T13:00:02.474+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":21.5,\"Chest\":50,\"Waist\":50,\"Bicep\":17,\"Sleeve\":26,\"Length\":32},\"Shirt\":{\"Neck\":18},\"Trouser\":{\"Waist\":41.5,\"Hips\":47,\"Thigh\":31,\"Knee\":22,\"Bottom\":19,\"Length\":42,\"Crotch\":31}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_19280812_d033_4be2_8f99_82541c0adcb9, v_org_id, 'Levi Nyamwaro', '0714545811', '[{"date": "2025-12-16T17:56:53.995+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":17.5,\"Chest\":39,\"Waist\":34.5,\"Bicep\":14,\"Sleeve\":24,\"Length\":28},\"Shirt\":{},\"Trouser\":{\"Waist\":34,\"Thigh\":28,\"Knee\":17.5,\"Bottom\":14,\"Length\":39,\"Crotch\":28}}"}]'::jsonb, 'Suit', '2322#black
2pc suit');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_1a2fcd38_6e5a_40d9_b74b_1e5795147c53, v_org_id, 'Derrick Musumbu', '0716982727', '[{"date": "2025-12-19T09:16:18.137+00:00", "garment": "Trouser", "measurements": "{\"Trouser\":{\"Waist\":39.5,\"Hips\":48.5,\"Thigh\":31,\"Knee\":20,\"Bottom\":14,\"Length\":39,\"Crotch\":29.5}}"}]'::jsonb, 'Trouser', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_29e57704_f083_41d4_aabb_f949c12b1f15, v_org_id, 'Mr Ezekiel', '0720352397', '[{"date": "2025-12-16T07:59:57.992+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":18,\"Chest\":42.5,\"Waist\":40.5,\"Bicep\":15,\"Sleeve\":25,\"Length\":30},\"Shirt\":{},\"Trouser\":{\"Waist\":40.5,\"Hips\":47.5,\"Thigh\":29,\"Knee\":20,\"Bottom\":16,\"Length\":43,\"Crotch\":29.5}}"}]'::jsonb, 'Suit', 'Turquoise green tuxedo with black pointed collar');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_39a9f07b_7b7f_4e99_9c8f_931fa3c00630, v_org_id, 'SHELDON(emmas boutique)', '0769075480', '[{"date": "2025-12-09T14:15:42.014+00:00", "garment": "Shirt", "measurements": "{\"Shirt\":{\"Shoulder\":16.5,\"Chest\":34.5,\"Waist\":28,\"Length\":26.5,\"Neck\":14}}"}]'::jsonb, 'Shirt', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_492da2a1_90d9_48d7_9fec_86a46d8280e0, v_org_id, 'Mr Josphat Langat', '0701097283', '[{"date": "2025-12-16T08:16:30.174+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":19,\"Chest\":41.5,\"Waist\":40.5,\"Bicep\":14.5,\"Sleeve\":25.5,\"Length\":29},\"Shirt\":{},\"Trouser\":{\"Waist\":38,\"Thigh\":27,\"Knee\":18,\"Bottom\":15,\"Length\":41,\"Crotch\":27.5}}"}]'::jsonb, 'Suit', '2pc 7808#13
one button two cut 
');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_52834b02_ccc6_4f0c_ac9d_df3a680c5b18, v_org_id, 'George Olweya', '0723902118', '[{"date": "2025-12-15T07:43:01.038+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":20,\"Chest\":46,\"Waist\":44.5,\"Bicep\":15,\"Sleeve\":27.5,\"Length\":35},\"Shirt\":{\"Neck\":18},\"Trouser\":{\"Waist\":41,\"Thigh\":33,\"Knee\":22,\"Bottom\":17.5,\"Length\":46,\"Crotch\":32}}"}]'::jsonb, 'Suit', '3 suits(2pc)
Black,Black and Blue.
Two buttons Two cut(2 Suits)
Three buttons Two Cuts(1 Suit)
Two materials are from the client');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_5369681a_1710_4e0f_a6f8_7f00420a61d7, v_org_id, 'Michael Mutitu', '0702256935', '[{"date": "2026-02-23T11:27:21.681+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":18,\"Chest\":43,\"Waist\":41.5,\"Bicep\":15,\"Sleeve\":24,\"Length\":29,\"Hips\":43},\"Shirt\":{},\"Trouser\":{\"Waist\":37,\"Hips\":45,\"Thigh\":28.5,\"Knee\":17.5,\"Bottom\":15,\"Length\":37.5,\"Crotch\":28.5}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_54904eb1_e956_4b83_8bfa_51dcb0ec9e27, v_org_id, 'Alex Muturi', '0740191321', '[{"date": "2026-02-16T01:24:23.793+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":19,\"Chest\":40,\"Waist\":36,\"Bicep\":14,\"Sleeve\":26.5,\"Length\":30},\"Shirt\":{},\"Trouser\":{\"Waist\":37,\"Hips\":45,\"Thigh\":28.5,\"Knee\":18,\"Bottom\":14,\"Length\":41,\"Crotch\":29}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_676d040a_1a90_401d_8031_2c869374bd29, v_org_id, 'Dr Michelle Abuya', '0724782326', '[{"date": "2025-12-15T08:00:16.129+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":17,\"Chest\":49,\"Waist\":41.5,\"Bicep\":16.5,\"Length\":27.5,\"Hips\":47.5},\"Shirt\":{},\"Trouser\":{\"Waist\":41,\"Hips\":52,\"Thigh\":33.5,\"Knee\":21,\"Bottom\":15,\"Length\":41,\"Crotch\":33.5}}"}]'::jsonb, 'Suit', 'Sleeveless Doublebreasted trouser suit
P31#3');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_6847c431_ab9b_4a2e_abc2_71b1f2f808f8, v_org_id, 'Kyle Wachira', '0797786658', '[{"date": "2026-02-17T12:23:30.897+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":18,\"Chest\":41,\"Waist\":34,\"Bicep\":14,\"Sleeve\":24.5,\"Length\":28.5},\"Shirt\":{},\"Trouser\":{\"Waist\":35,\"Hips\":45,\"Thigh\":28.5,\"Knee\":18,\"Bottom\":14,\"Length\":40,\"Crotch\":29}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_6932cf9e_9d84_4019_ab17_cdc0d703b18d, v_org_id, 'Alex Mwangi', '0119582130', '[{"date": "2026-02-23T11:37:25.22+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":19,\"Chest\":46.5,\"Waist\":47.5,\"Bicep\":18,\"Sleeve\":24,\"Length\":29,\"Hips\":53},\"Shirt\":{\"Neck\":15.5},\"Trouser\":{\"Waist\":45,\"Hips\":55,\"Thigh\":34,\"Knee\":22,\"Bottom\":17,\"Length\":38.5,\"Crotch\":34}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_707cfec1_74ac_4e0c_8c83_6e69468a091d, v_org_id, 'Shalom', '0701404899', '[{"date": "2026-02-23T11:53:26.048+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":17,\"Chest\":37,\"Waist\":33,\"Bicep\":14.5,\"Sleeve\":25,\"Length\":28},\"Shirt\":{},\"Trouser\":{\"Waist\":32,\"Thigh\":24,\"Knee\":17,\"Bottom\":12.5,\"Length\":38.5,\"Crotch\":26}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_70aabf51_2941_44ef_872e_be9bc18e81ce, v_org_id, 'Don Laat', '+211922065533', '[{"date": "2025-12-17T07:13:53.596+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":19.5,\"Chest\":38,\"Waist\":33,\"Bicep\":15,\"Sleeve\":25.5,\"Length\":30},\"Shirt\":{},\"Trouser\":{\"Waist\":33.5,\"Hips\":40,\"Thigh\":25,\"Bottom\":14,\"Length\":41.5,\"Crotch\":28}}"}]'::jsonb, 'Suit', '2068#25
baggy doublebreast suit
only inside buttons
');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_7722c9f5_ecfa_43d2_913e_4c7bed8aa07b, v_org_id, 'Mr George (vigilance)', '0722742211', '[{"date": "2026-01-06T13:15:58.274+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":21,\"Chest\":50,\"Bodice\":47,\"Waist\":47,\"Bicep\":18,\"Sleeve\":26.5,\"Length\":31},\"Shirt\":{},\"Trouser\":{\"Waist\":45,\"Thigh\":32.5,\"Knee\":22,\"Bottom\":18,\"Length\":42.5,\"Crotch\":30}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_9086d37a_8728_4782_957d_28b111f31da3, v_org_id, 'Ethan', '0722643118', '[{"date": "2026-02-17T12:27:16.113+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":17,\"Chest\":34,\"Waist\":30,\"Bicep\":12,\"Sleeve\":24,\"Length\":27},\"Shirt\":{},\"Trouser\":{\"Waist\":31.5,\"Hips\":38,\"Thigh\":25.5,\"Knee\":17.5,\"Bottom\":14,\"Length\":40,\"Crotch\":26.5}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_a0464ccc_dbf8_42e2_b07c_2a0f01921a73, v_org_id, 'Euticus Baraka', '0722144105', '[{"date": "2025-12-09T07:48:43.793+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":14,\"Chest\":26,\"Waist\":24,\"Sleeve\":19,\"Length\":20,\"Hips\":28},\"Shirt\":{},\"Trouser\":{\"Waist\":24,\"Thigh\":17,\"Bottom\":13,\"Length\":30}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_c7ae6e79_353b_4e8f_b4dc_8994c6caa57d, v_org_id, 'Edwin Lelei', '0711732033', '[{"date": "2025-12-09T07:58:47.935+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":20,\"Chest\":50,\"Waist\":49.5,\"Bicep\":17,\"Sleeve\":10,\"Length\":32},\"Shirt\":{\"Neck\":16.5},\"Trouser\":{\"Waist\":40.5,\"Thigh\":28,\"Knee\":17.5,\"Bottom\":13.5,\"Length\":40,\"Crotch\":28}}"}]'::jsonb, 'Suit', 'Rinear 3#13
Short sleeve 4 pockets kaunda');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_cc0fb17f_e2ee_41d7_9169_9d42cdc7583a, v_org_id, 'JENNIFER', '0729471214', '[{"date": "2025-12-10T08:33:19.349+00:00", "garment": "Shirt", "measurements": "{\"Shirt\":{\"Shoulder\":15,\"Chest\":38,\"Waist\":32,\"Length\":22,\"Neck\":13.5}}"}]'::jsonb, 'Shirt', 'Cotton Biege uniform shirts for emmas boutique
3 pieces');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_d1113880_3bac_4423_8654_dff214edbbd9, v_org_id, 'The Don', '0702386111', '[{"date": "2025-12-19T08:28:04.654+00:00", "garment": "Suit", "measurements": "{\"Coat\":{},\"Shirt\":{\"Shoulder\":18.5,\"Chest\":42,\"Waist\":41,\"Sleeve\":25.5,\"Length\":29},\"Trouser\":{\"Waist\":38,\"Hips\":43,\"Thigh\":27,\"Knee\":17,\"Bottom\":13.5,\"Length\":38,\"Crotch\":27}}"}]'::jsonb, 'Suit', '272 offwhite kaunda
shortsleeve 4 pockets');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_e48883e9_6435_44dd_86b3_677ebbca223f, v_org_id, 'Edwin Magangi', '0708648857', '[{"date": "2025-12-18T17:28:43.908+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":20.5,\"Chest\":45,\"Waist\":40.5,\"Bicep\":16,\"Sleeve\":24.5,\"Length\":28.5},\"Shirt\":{},\"Trouser\":{\"Waist\":39.5,\"Hips\":47,\"Thigh\":30,\"Knee\":30,\"Bottom\":14,\"Length\":39,\"Crotch\":30}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_e8207ed0_2bdd_40f2_b133_e7354b6595bd, v_org_id, 'Francis Muchai', '0721854758', '[{"date": "2025-12-19T09:11:13.19+00:00", "garment": "Half Coat", "measurements": "{\"Coat\":{\"Shoulder\":19.5,\"Chest\":42,\"Waist\":37.5,\"Length\":26}}"}]'::jsonb, 'Half Coat', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_e9133905_2d99_4fe9_8de3_c5d29b7bc1d2, v_org_id, 'Matthew Maina', '0725151314', '[{"date": "2026-01-05T09:52:51.278+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":19.5,\"Chest\":46,\"Waist\":43,\"Bicep\":16,\"Sleeve\":25.5,\"Length\":29},\"Shirt\":{},\"Trouser\":{\"Waist\":39,\"Hips\":46,\"Thigh\":30,\"Knee\":19.5,\"Bottom\":14,\"Length\":39,\"Crotch\":29}}"}]'::jsonb, 'Suit', '');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes) 
VALUES (v_client_ee57260a_457d_4ed1_a34c_a8783b797c94, v_org_id, 'Sean Njuguna', '0728125540', '[{"date": "2026-01-05T10:05:17.504+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":18.5,\"Chest\":42,\"Waist\":43.5,\"Bicep\":14.5,\"Sleeve\":26,\"Length\":29},\"Shirt\":{},\"Trouser\":{\"Waist\":41,\"Hips\":48,\"Thigh\":29.5,\"Knee\":18,\"Bottom\":14,\"Length\":41,\"Crotch\":29.5}}"}]'::jsonb, 'Suit', 'P31#Black 
2pc suit
2black shirts');

-- 6. Import Orders
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_23, v_org_id, v_shop_id, v_manager_id, 'Euticus Baraka', '0722144105', 'Suit', '{"Coat":{"Shoulder":14,"Chest":26,"Waist":24,"Sleeve":19,"Length":20,"Hips":28},"Shirt":{},"Trouser":{"Waist":24,"Thigh":17,"Bottom":13,"Length":30}}'::jsonb, 8000, 8000, 7, '2025-12-09 07:48:43.793+00', '', v_worker_23, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_24, v_org_id, v_shop_id, v_manager_id, 'Edwin Lelei', '0711732033', 'Suit', '{"Coat":{"Shoulder":20,"Chest":50,"Waist":49.5,"Bicep":17,"Sleeve":10,"Length":32},"Shirt":{"Neck":16.5},"Trouser":{"Waist":40.5,"Thigh":28,"Knee":17.5,"Bottom":13.5,"Length":40,"Crotch":28}}'::jsonb, 15000, 15000, 7, '2025-12-09 07:58:47.935+00', 'Rinear 3#13
Short sleeve 4 pockets kaunda', v_worker_18, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_25, v_org_id, v_shop_id, v_manager_id, 'Earnest Kimitei', '0722757079  ', 'Suit', '{"Coat":{"Shoulder":19,"Chest":46,"Waist":44.5,"Bicep":15,"Sleeve":9.5,"Length":32},"Shirt":{"Neck":17.5},"Trouser":{"Waist":42,"Thigh":28,"Knee":19,"Bottom":15.5,"Length":41,"Crotch":29}}'::jsonb, 30000, 30000, 7, '2025-12-09 08:23:10.202+00', 'Kaunda
Rinear 3#12
Short sleeve 4 pockets
2nd kaunda
4 pockets short sleeve
R6#PB30', v_worker_18, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_26, v_org_id, v_shop_id, v_manager_id, 'SHELDON(emmas boutique)', '0769075480', 'Shirt', '{"Shirt":{"Shoulder":16.5,"Chest":34.5,"Waist":28,"Length":26.5,"Neck":14}}'::jsonb, 10500, 10500, 7, '2025-12-09 14:15:42.014+00', '', v_worker_18, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_27, v_org_id, v_shop_id, v_manager_id, 'JENNIFER', '0729471214', 'Shirt', '{"Shirt":{"Shoulder":15,"Chest":38,"Waist":32,"Length":22,"Neck":13.5}}'::jsonb, 10500, 10500, 7, '2025-12-10 08:33:19.349+00', 'Cotton Biege uniform shirts for emmas boutique
3 pieces', v_worker_20, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_28, v_org_id, v_shop_id, v_manager_id, 'George Olweya', '0723902118', 'Suit', '{"Coat":{"Shoulder":20,"Chest":46,"Waist":44.5,"Bicep":15,"Sleeve":27.5,"Length":35},"Shirt":{"Neck":18},"Trouser":{"Waist":41,"Thigh":33,"Knee":22,"Bottom":17.5,"Length":46,"Crotch":32}}'::jsonb, 38000, 38000, 7, '2025-12-15 07:43:01.038+00', '3 suits(2pc)
Black,Black and Blue.
Two buttons Two cut(2 Suits)
Three buttons Two Cuts(1 Suit)
Two materials are from the client', v_worker_24, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_30, v_org_id, v_shop_id, v_manager_id, 'Mr Simon Kipruto', '0728263487', 'Suit', '{"Coat":{"Shoulder":18,"Chest":40,"Waist":38,"Bicep":14.5,"Sleeve":24,"Length":29},"Shirt":{},"Trouser":{"Waist":36.5,"Thigh":28,"Knee":18.5,"Bottom":15.5,"Length":41.5,"Crotch":28.5}}'::jsonb, 7000, 7000, 7, '2025-12-15 16:16:40.929+00', 'Blue senator suit.
2068#2', v_worker_18, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_31, v_org_id, v_shop_id, v_manager_id, 'Mr Ezekiel', '0720352397', 'Suit', '{"Coat":{"Shoulder":18,"Chest":42.5,"Waist":40.5,"Bicep":15,"Sleeve":25,"Length":30},"Shirt":{},"Trouser":{"Waist":40.5,"Hips":47.5,"Thigh":29,"Knee":20,"Bottom":16,"Length":43,"Crotch":29.5}}'::jsonb, 12000, 12000, 7, '2025-12-16 07:59:57.992+00', 'Turquoise green tuxedo with black pointed collar', v_worker_22, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_32, v_org_id, v_shop_id, v_manager_id, 'Mr Josphat Langat', '0701097283', 'Suit', '{"Coat":{"Shoulder":19,"Chest":41.5,"Waist":40.5,"Bicep":14.5,"Sleeve":25.5,"Length":29},"Shirt":{},"Trouser":{"Waist":38,"Thigh":27,"Knee":18,"Bottom":15,"Length":41,"Crotch":27.5}}'::jsonb, 32000, 38000, 7, '2025-12-16 08:16:30.174+00', '2pc 7808#13
one button two cut 
', v_worker_22, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_33, v_org_id, v_shop_id, v_manager_id, 'Levi Nyamwaro', '0714545811', 'Suit', '{"Coat":{"Shoulder":17.5,"Chest":39,"Waist":34.5,"Bicep":14,"Sleeve":24,"Length":28},"Shirt":{},"Trouser":{"Waist":34,"Thigh":28,"Knee":17.5,"Bottom":14,"Length":39,"Crotch":28}}'::jsonb, 84000, 84000, 2, '2025-12-16 17:56:53.995+00', '4 suits

2322#black
62511#1204
C90#3
2068#7
2068#4
2pc suit', v_worker_24, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_34, v_org_id, v_shop_id, v_manager_id, 'Don Laat', '+211922065533', 'Suit', '{"Coat":{"Shoulder":19.5,"Chest":38,"Waist":33,"Bicep":15,"Sleeve":25.5,"Length":30},"Shirt":{},"Trouser":{"Waist":33.5,"Hips":40,"Thigh":25,"Bottom":14,"Length":41.5,"Crotch":28}}'::jsonb, 15500, 15500, 7, '2025-12-17 07:13:53.596+00', '2068#25
baggy doublebreast suit
only inside buttons
', v_worker_24, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_36, v_org_id, v_shop_id, v_manager_id, 'Edwin Magangi', '0708648857', 'Suit', '{"Coat":{"Shoulder":20.5,"Chest":45,"Waist":40.5,"Bicep":16,"Sleeve":24.5,"Length":28.5},"Shirt":{},"Trouser":{"Waist":39.5,"Hips":47,"Thigh":30,"Knee":30,"Bottom":14,"Length":39,"Crotch":30}}'::jsonb, 18500, 18500, 7, '2025-12-18 17:28:43.908+00', '', v_worker_22, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_37, v_org_id, v_shop_id, v_manager_id, 'The Don', '0702386111', 'Suit', '{"Coat":{},"Shirt":{"Shoulder":18.5,"Chest":42,"Waist":41,"Sleeve":25.5,"Length":29},"Trouser":{"Waist":38,"Hips":43,"Thigh":27,"Knee":17,"Bottom":13.5,"Length":38,"Crotch":27}}'::jsonb, 16000, 16000, 7, '2025-12-19 08:28:04.654+00', '272 offwhite kaunda
shortsleeve 4 pockets', v_worker_18, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_39, v_org_id, v_shop_id, v_manager_id, 'Francis Muchai', '0721854758', 'Half Coat', '{"Coat":{"Shoulder":19.5,"Chest":42,"Waist":37.5,"Length":26}}'::jsonb, 5500, 5500, 7, '2025-12-19 09:11:13.19+00', '', v_worker_30, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_40, v_org_id, v_shop_id, v_manager_id, 'Derrick Musumbu', '0716982727', 'Trouser', '{"Trouser":{"Waist":39.5,"Hips":48.5,"Thigh":31,"Knee":20,"Bottom":14,"Length":39,"Crotch":29.5}}'::jsonb, 5500, 5500, 7, '2025-12-19 09:16:18.137+00', '', v_worker_31, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_41, v_org_id, v_shop_id, v_manager_id, 'BOBBY MAINA', '0725151314', 'Suit', '{"Coat":{"Shoulder":12.5,"Chest":24,"Waist":21,"Bicep":9,"Sleeve":17,"Length":20},"Shirt":{"Neck":11},"Trouser":{"Waist":22.5,"Thigh":17,"Knee":13,"Bottom":11,"Length":26,"Crotch":17}}'::jsonb, 10000, 10000, 7, '2026-01-05 09:42:16.007+00', '', v_worker_23, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_42, v_org_id, v_shop_id, v_manager_id, 'BOB MAINA', '0725151314', 'Suit', '{"Coat":{"Shoulder":14,"Chest":32,"Waist":31,"Bicep":11.5,"Sleeve":19,"Length":24},"Shirt":{"Neck":12},"Trouser":{"Waist":29.5,"Hips":35,"Thigh":23,"Knee":16,"Bottom":11.5,"Length":31,"Crotch":22}}'::jsonb, 10000, 10000, 7, '2026-01-05 09:42:17.058+00', '', v_worker_23, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_43, v_org_id, v_shop_id, v_manager_id, 'Matthew Maina', '0725151314', 'Suit', '{"Coat":{"Shoulder":19.5,"Chest":46,"Waist":43,"Bicep":16,"Sleeve":25.5,"Length":29},"Shirt":{},"Trouser":{"Waist":39,"Hips":46,"Thigh":30,"Knee":19.5,"Bottom":14,"Length":39,"Crotch":29}}'::jsonb, 14000, 14000, 7, '2026-01-05 09:52:51.278+00', '', v_worker_24, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_44, v_org_id, v_shop_id, v_manager_id, 'Ethan Maina', '0725151314', 'Suit', '{"Coat":{"Shoulder":14.5,"Chest":28.5,"Waist":26,"Bicep":10.5,"Sleeve":17.5,"Length":21.5},"Shirt":{"Neck":12},"Trouser":{"Waist":25.5,"Hips":32,"Thigh":20,"Knee":13,"Bottom":11.5,"Length":29,"Crotch":20}}'::jsonb, 10000, 10000, 7, '2026-01-05 09:57:42.684+00', '', v_worker_23, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_45, v_org_id, v_shop_id, v_manager_id, 'Sean Njuguna', '0728125540', 'Suit', '{"Coat":{"Shoulder":18.5,"Chest":42,"Waist":43.5,"Bicep":14.5,"Sleeve":26,"Length":29},"Shirt":{},"Trouser":{"Waist":41,"Hips":48,"Thigh":29.5,"Knee":18,"Bottom":14,"Length":41,"Crotch":29.5}}'::jsonb, 17000, 17000, 7, '2026-01-05 10:05:17.504+00', 'P31#Black 
2pc suit
2black shirts', v_worker_20, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_46, v_org_id, v_shop_id, v_manager_id, 'Bishop Kepha Omae', '0722743515', 'Suit', '{"Coat":{"Shoulder":21.5,"Chest":50,"Waist":50,"Bicep":17,"Sleeve":26,"Length":32},"Shirt":{"Neck":18},"Trouser":{"Waist":41.5,"Hips":47,"Thigh":31,"Knee":22,"Bottom":19,"Length":42,"Crotch":31}}'::jsonb, 22000, 22000, 7, '2026-01-06 13:00:02.474+00', '', v_worker_24, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_47, v_org_id, v_shop_id, v_manager_id, 'Mr George (vigilance)', '0722742211', 'Suit', '{"Coat":{"Shoulder":21,"Chest":50,"Bodice":47,"Waist":47,"Bicep":18,"Sleeve":26.5,"Length":31},"Shirt":{},"Trouser":{"Waist":45,"Thigh":32.5,"Knee":22,"Bottom":18,"Length":42.5,"Crotch":30}}'::jsonb, 20000, 20000, 7, '2026-01-06 13:15:58.274+00', '', v_worker_24, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_48, v_org_id, v_shop_id, v_manager_id, 'Alex Muturi', '0740191321', 'Suit', '{"Coat":{"Shoulder":19,"Chest":40,"Waist":36,"Bicep":14,"Sleeve":26.5,"Length":30},"Shirt":{},"Trouser":{"Waist":37,"Hips":45,"Thigh":28.5,"Knee":18,"Bottom":14,"Length":41,"Crotch":29}}'::jsonb, 16000, 16000, 7, '2026-02-16 01:24:23.793+00', '62511#1204 
Three piece suit 
White shirt', v_worker_22, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_49, v_org_id, v_shop_id, v_manager_id, 'Kyle Wachira', '0797786658', 'Suit', '{"Coat":{"Shoulder":18,"Chest":41,"Waist":34,"Bicep":14,"Sleeve":24.5,"Length":28.5},"Shirt":{},"Trouser":{"Waist":35,"Hips":45,"Thigh":28.5,"Knee":18,"Bottom":14,"Length":40,"Crotch":29}}'::jsonb, 17000, 17000, 7, '2026-02-17 12:23:30.897+00', '', v_worker_22, '"[\"31\",\"23\",\"18\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_50, v_org_id, v_shop_id, v_manager_id, 'Ethan', '0722643118', 'Suit', '{"Coat":{"Shoulder":17,"Chest":34,"Waist":30,"Bicep":12,"Sleeve":24,"Length":27},"Shirt":{},"Trouser":{"Waist":31.5,"Hips":38,"Thigh":25.5,"Knee":17.5,"Bottom":14,"Length":40,"Crotch":26.5}}'::jsonb, 16000, 16000, 7, '2026-02-17 12:27:16.113+00', '', v_worker_23, '"[\"31\",\"18\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_51, v_org_id, v_shop_id, v_manager_id, 'Michael Mutitu', '0702256935', 'Suit', '{"Coat":{"Shoulder":18,"Chest":43,"Waist":41.5,"Bicep":15,"Sleeve":24,"Length":29,"Hips":43},"Shirt":{},"Trouser":{"Waist":37,"Hips":45,"Thigh":28.5,"Knee":17.5,"Bottom":15,"Length":37.5,"Crotch":28.5}}'::jsonb, 14000, 14000, 7, '2026-02-23 11:27:21.681+00', '', v_worker_24, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_52, v_org_id, v_shop_id, v_manager_id, 'Alex Mwangi', '0119582130', 'Suit', '{"Coat":{"Shoulder":19,"Chest":46.5,"Waist":47.5,"Bicep":18,"Sleeve":24,"Length":29,"Hips":53},"Shirt":{"Neck":15.5},"Trouser":{"Waist":45,"Hips":55,"Thigh":34,"Knee":22,"Bottom":17,"Length":38.5,"Crotch":34}}'::jsonb, 15000, 15000, 7, '2026-02-23 11:37:25.22+00', '', v_worker_24, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_53, v_org_id, v_shop_id, v_manager_id, 'Shalom', '0701404899', 'Suit', '{"Coat":{"Shoulder":17,"Chest":37,"Waist":33,"Bicep":14.5,"Sleeve":25,"Length":28},"Shirt":{},"Trouser":{"Waist":32,"Thigh":24,"Knee":17,"Bottom":12.5,"Length":38.5,"Crotch":26}}'::jsonb, 12000, 12000, 7, '2026-02-23 11:53:26.048+00', '', v_worker_23, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_58, v_org_id, v_shop_id, v_manager_id, 'Rahma', '0707687170', 'Suit', '{"Coat":{"Shoulder":15,"Chest":36,"Bodice":17,"Waist":32,"Bicep":13,"Sleeve":22,"Length":28,"Hips":45},"Shirt":{},"Trouser":{"Waist":29,"Hips":45,"Thigh":28,"Bottom":22,"Length":38,"Crotch":26}}'::jsonb, 60000, 60000, 7, '2026-02-27 14:05:23.671+00', '', v_worker_21, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_59, v_org_id, v_shop_id, v_manager_id, 'Evans Ongoro', '0723769469', 'Shirt', '{"Shirt":{"Shoulder":21,"Chest":47,"Bust":47,"Waist":45,"Short Sleeve":10,"Length":34}}'::jsonb, 12000, 16000, 7, '2026-03-02 09:53:55.625+00', '', v_worker_18, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_60, v_org_id, v_shop_id, v_manager_id, 'Solomon Ogolla', '0728534119', 'Suit', '{"Coat":{"Shoulder":18,"Chest":41,"Waist":38,"Bicep":14,"Sleeve":24,"Length":28},"Shirt":{"Neck":15},"Trouser":{"Waist":34.5,"Thigh":26,"Knee":18.5,"Bottom":14,"Length":39.5,"Crotch":27.5}}'::jsonb, 16000, 16000, 7, '2026-03-02 10:03:21.832+00', '', v_worker_22, '"[\"23\",\"18\",\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_61, v_org_id, v_shop_id, v_manager_id, 'Paul Ngono', '0727572839', 'Suit', '{"Coat":{"Shoulder":18,"Chest":43,"Waist":39,"Bicep":15.5,"Sleeve":25,"Length":28},"Shirt":{},"Trouser":{"Waist":39,"Hips":47,"Thigh":29,"Knee":18.5,"Bottom":15,"Length":40,"Crotch":29}}'::jsonb, 14000, 14000, 7, '2026-03-03 14:02:30.675+00', '', v_worker_22, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_62, v_org_id, v_shop_id, v_manager_id, 'George Amolo', '0710752759', 'Suit', '{"Coat":{"Shoulder":19,"Chest":38.5,"Waist":32,"Bicep":14,"Sleeve":24,"Length":28.5,"Hips":40.5},"Shirt":{},"Trouser":{"Waist":32.5,"Hips":40.5,"Thigh":25.5,"Knee":17.5,"Bottom":15.5,"Length":41,"Crotch":27.5}}'::jsonb, 12000, 8000, 1, '2026-03-10 16:24:47.169+00', 'Suit 
double breast pinstripped
shirt own materila normal', v_worker_22, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_63, v_org_id, v_shop_id, v_manager_id, 'Mr Peter(Donholm wedding)', '0723640363', 'Suit', '{"Coat":{"Shoulder":19,"Chest":42,"Waist":39,"Bicep":15,"Sleeve":23,"Length":28.5,"Hips":38.5},"Shirt":{},"Trouser":{"Waist":35,"Hips":42.5,"Thigh":27,"Knee":19,"Bottom":14,"Length":38.5,"Crotch":28.5}}'::jsonb, 15000, 15000, 7, '2026-03-11 06:42:01.349+00', '', v_worker_31, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_64, v_org_id, v_shop_id, v_manager_id, 'Brenden', '07233640363', 'Suit', '{"Coat":{"Shoulder":15.5,"Chest":31,"Waist":25.5,"Bicep":10.5,"Sleeve":21.5,"Length":23},"Shirt":{},"Trouser":{"Waist":27,"Hips":34,"Thigh":23,"Knee":15.5,"Bottom":12.5,"Length":35,"Crotch":24}}'::jsonb, 11000, 11000, 7, '2026-03-11 06:47:33.842+00', '', v_worker_31, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_65, v_org_id, v_shop_id, v_manager_id, 'Shon(Donholm wedding)', '0723640363', 'Suit', '{"Coat":{"Shoulder":17.5,"Chest":34.5,"Waist":28,"Bicep":12.5,"Sleeve":22.5,"Length":26},"Shirt":{},"Trouser":{"Waist":28.5,"Thigh":22.5,"Knee":16,"Bottom":12.5,"Length":37,"Crotch":25}}'::jsonb, 12000, 12000, 7, '2026-03-11 06:53:07.18+00', '', v_worker_31, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_66, v_org_id, v_shop_id, v_manager_id, 'Moses Ngonze', '0727531410', 'Kaunda/Senator Suit', '{"Top":{"Shoulder":18.5,"Sleeve":25,"Arm":14,"Chest":42,"Waist":41.5,"Length":29},"Trouser":{"Waist":36.5,"Thigh":29.5,"Knee":21,"Bottom":17.5,"Length":42,"Crotch":30}}'::jsonb, 12500, 12500, 7, '2026-03-11 09:48:08.99+00', '', v_worker_18, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_67, v_org_id, v_shop_id, v_manager_id, 'Ajay Shah', '0722415001', 'Suit', '{"Coat":{"Shoulder":19,"Chest":45.5,"Waist":46,"Bicep":14,"Sleeve":24,"Length":29},"Shirt":{},"Trouser":{"Waist":38.5,"Hips":0,"Thigh":27,"Knee":18,"Bottom":14,"Length":37.5,"Crotch":28}}'::jsonb, 14000, 14000, 7, '2026-03-11 10:03:33.495+00', '', v_worker_24, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_68, v_org_id, v_shop_id, v_manager_id, 'Ken Muluki(Kyuma wedding)', '0704510707', 'Suit', '{"Coat":{"Shoulder":19.5,"Chest":41,"Waist":37,"Bicep":15.5,"Sleeve":26,"Length":28.5,"Hips":43.5},"Shirt":{},"Trouser":{"Waist":37.5,"Hips":43.5,"Thigh":29,"Knee":19.5,"Bottom":14.5,"Length":41,"Crotch":29}}'::jsonb, 13000, 8000, 1, '2026-03-12 09:53:44.329+00', '', v_worker_22, '"[\"23\",\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_69, v_org_id, v_shop_id, v_manager_id, 'Kevin Odonde(Kyumas Wedding)', '0741404728', 'Suit', '{"Coat":{"Shoulder":19.5,"Waist":37,"Sleeve":27,"Length":30,"Hips":44},"Shirt":{},"Trouser":{"Waist":37,"Thigh":27,"Knee":18,"Bottom":14,"Length":43,"Crotch":29}}'::jsonb, 13000, 5000, 1, '2026-03-12 10:36:56.869+00', '', v_worker_22, '"[\"23\",\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_70, v_org_id, v_shop_id, v_manager_id, 'Dennis(Kyumas Wedding)', '0708758135', 'Suit', '{"Coat":{"Shoulder":17,"Chest":39,"Waist":38,"Sleeve":24.5,"Length":28},"Shirt":{},"Trouser":{"Waist":35.5,"Hips":40,"Thigh":26,"Knee":15,"Bottom":13,"Length":39}}'::jsonb, 13000, 5000, 1, '2026-03-12 10:46:26.912+00', '', v_worker_22, '"[\"23\",\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_71, v_org_id, v_shop_id, v_manager_id, 'Martin Mburu', '0745551461', 'Suit', '{"Coat":{"Shoulder":17.5,"Chest":37,"Waist":29,"Bicep":12.5,"Sleeve":23.5,"Length":27},"Shirt":{},"Trouser":{"Waist":32,"Thigh":24.5,"Knee":15.5,"Bottom":12.5,"Length":38,"Crotch":26.5}}'::jsonb, 13000, 13000, 7, '2026-03-12 10:59:09.96+00', '', v_worker_23, '"[\"23\",\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_72, v_org_id, v_shop_id, v_manager_id, 'Kuria Maina', '0743324484', 'Coat', '{"Coat":{"Shoulder":18,"Chest":41,"Waist":38.5,"Sleeve":25,"Length":29.5}}'::jsonb, 12000, 12000, 7, '2026-03-12 11:15:20.582+00', '2 Bemuta checked coats', v_worker_22, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_73, v_org_id, v_shop_id, v_manager_id, 'Geoffrey Kyuma', '07019587549', 'Suit', '{"Coat":{"Shoulder":17,"Chest":38,"Bicep":13.5,"Sleeve":24.5,"Length":27,"Hips":40},"Shirt":{},"Trouser":{"Waist":32.5,"Hips":40,"Thigh":27,"Knee":17,"Bottom":13.5,"Length":38,"Crotch":27.5}}'::jsonb, 19000, 14000, 1, '2026-03-13 08:42:45.859+00', '', v_worker_24, '"[\"23\",\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_74, v_org_id, v_shop_id, v_manager_id, 'Marial', '0743037326', 'Suit', '{"Coat":{"Shoulder":20,"Chest":41.5,"Waist":34,"Bicep":14.5,"Sleeve":27.5,"Length":33,"Hips":0},"Shirt":{"Neck":16},"Trouser":{"Waist":34,"Thigh":28.5,"Knee":19,"Bottom":15,"Length":46.5,"Crotch":29}}'::jsonb, 17000, 17000, 7, '2026-03-16 10:37:59.477+00', '', v_worker_23, '"[\"31\",\"20\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_75, v_org_id, v_shop_id, v_manager_id, 'Dorel', '0712446350', 'Suit', '{"Coat":{"Shoulder":20.5,"Chest":45,"Waist":44.5,"Bicep":15.5,"Sleeve":26.5,"Length":33,"Hips":48.5},"Shirt":{},"Trouser":{"Waist":40,"Hips":48.5,"Thigh":33.5,"Knee":19.5,"Bottom":14.5,"Length":45,"Crotch":33.5}}'::jsonb, 18000, 18000, 7, '2026-03-16 11:16:34.093+00', '', v_worker_24, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_76, v_org_id, v_shop_id, v_manager_id, 'Raul Dorel', '0712446350', 'Suit', '{"Coat":{"Shoulder":17.5,"Chest":38,"Waist":34,"Bicep":14,"Sleeve":24.5,"Length":28},"Shirt":{},"Trouser":{"Waist":34,"Thigh":27,"Knee":17,"Bottom":14,"Length":40,"Crotch":28.5}}'::jsonb, 18000, 18000, 7, '2026-03-16 11:19:57.473+00', '', v_worker_24, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_77, v_org_id, v_shop_id, v_manager_id, 'Steve (Divinas Wedding Groom)', '0706246', 'Suit', '{"Coat":{"Shoulder":18,"Chest":38.5,"Waist":33,"Bicep":14,"Sleeve":24.5,"Length":27.5,"Hips":39},"Shirt":{"Neck":15.5},"Trouser":{"Waist":32.5,"Hips":39,"Thigh":25,"Knee":17,"Bottom":14,"Length":38.5,"Crotch":26.5}}'::jsonb, 15000, 15000, 7, '2026-03-24 17:47:10.621+00', '', v_worker_24, '"[\"23\",\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_78, v_org_id, v_shop_id, v_manager_id, 'Sean Stanley', '0740556348', 'Trouser', '{"Trouser":{"Waist":36,"Hips":47,"Thigh":30,"Knee":30,"Bottom":14,"Length":39,"Crotch":30}}'::jsonb, 15000, 8000, 1, '2026-04-02 07:47:45.053+00', '', v_worker_19, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_80, v_org_id, v_shop_id, v_manager_id, 'MC Nyamu', '0717055105', 'Kaunda/Senator Suit', '{"Top":{"Shoulder":21,"Sleeve":24,"Arm":16.5,"Chest":46,"Waist":46,"Hips":49,"Length":30,"Neck":18},"Trouser":{"Waist":42.5,"Hips":49,"Thigh":31,"Knee":19.5,"Bottom":14.5,"Length":36,"Crotch":31}}'::jsonb, 16000, 16000, 7, '2026-04-02 07:56:07.452+00', '', v_worker_18, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_81, v_org_id, v_shop_id, v_manager_id, 'Andrew Sanaa', '0743126818', 'Suit', '{"Coat":{"Shoulder":18,"Chest":40,"Waist":36,"Bicep":14,"Sleeve":24.5,"Length":28},"Shirt":{},"Trouser":{"Waist":35.5,"Thigh":27.5,"Knee":17.5,"Bottom":15,"Length":39.5,"Crotch":27.5}}'::jsonb, 11000, 11000, 7, '2026-04-02 08:11:19.403+00', '', v_worker_24, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_82, v_org_id, v_shop_id, v_manager_id, 'Andrew Sanaa(Son)', '0743126818', 'Suit', '{"Coat":{"Shoulder":9.5,"Chest":22,"Waist":23,"Bicep":8.5,"Sleeve":13,"Length":17},"Shirt":{},"Trouser":{"Waist":19,"Length":20}}'::jsonb, 8000, 8000, 7, '2026-04-02 08:28:20.841+00', '', v_worker_23, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_83, v_org_id, v_shop_id, v_manager_id, 'Maxwell Ochola', '0725088988', 'Suit', '{"Coat":{"Shoulder":17.5,"Chest":38.5,"Waist":31.5,"Bicep":15.5,"Sleeve":24,"Length":27.5},"Shirt":{},"Trouser":{"Waist":30.5,"Thigh":26,"Knee":16,"Bottom":13,"Length":39,"Crotch":27}}'::jsonb, 15000, 15000, 7, '2026-04-04 08:43:23.664+00', '', v_worker_23, '"[\"31\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_84, v_org_id, v_shop_id, v_manager_id, 'Chris Omoro', '0722237015', 'Suit', '{"Coat":{"Shoulder":18,"Chest":41.5,"Waist":39,"Bicep":14,"Sleeve":24,"Length":29},"Shirt":{},"Trouser":{"Waist":37,"Hips":44,"Thigh":27.5,"Knee":18,"Bottom":15,"Length":40.5,"Crotch":28}}'::jsonb, 6500, 4000, 1, '2026-04-10 11:22:42.643+00', '', v_worker_22, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_85, v_org_id, v_shop_id, v_manager_id, 'Hon Sam Mburu', '0714423577', 'Suit', '{"Coat":{"Shoulder":18.5,"Chest":45,"Waist":46,"Bicep":15,"Sleeve":24.5,"Length":31},"Shirt":{},"Trouser":{"Waist":40,"Thigh":30,"Knee":19,"Bottom":16,"Length":41,"Crotch":29.5}}'::jsonb, 50000, 0, 1, '2026-04-14 12:24:00.781+00', '', v_worker_24, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_86, v_org_id, v_shop_id, v_manager_id, 'Mr Wangombe', '0721383415', 'Trouser', '{"Trouser":{"Waist":42.5,"Hips":48,"Thigh":29.5,"Knee":20,"Bottom":17,"Length":40,"Crotch":29}}'::jsonb, 18000, 10000, 1, '2026-04-15 14:35:23.563+00', '', v_worker_19, '"[]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_87, v_org_id, v_shop_id, v_manager_id, 'Michael Omollo', '0712905556', 'Suit', '{"Coat":{"Shoulder":18.5,"Chest":37.5,"Waist":32,"Bicep":13,"Sleeve":25,"Length":29.5},"Shirt":{},"Trouser":{"Waist":32,"Thigh":26.5,"Knee":17,"Bottom":14,"Length":42,"Crotch":28.5}}'::jsonb, 20000, 20000, 1, '2026-04-20 08:21:33.964+00', '', v_worker_24, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_88, v_org_id, v_shop_id, v_manager_id, 'Brian Bosire Nyachiru', '0705155604', 'Suit', '{"Coat":{"Shoulder":17,"Chest":41.5,"Bodice":0,"Waist":35,"Bicep":15,"Sleeve":24,"Length":27.5},"Shirt":{},"Trouser":{"Waist":34,"Hips":41.5,"Thigh":27.5,"Knee":17.5,"Bottom":14,"Length":39,"Crotch":28.5}}'::jsonb, 24000, 24000, 1, '2026-05-09 12:07:08.49+00', '', v_worker_22, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_89, v_org_id, v_shop_id, v_manager_id, 'Bob Kimani', '0768275111', 'Suit', '{"Coat":{"Shoulder":18,"Chest":42,"Waist":40.5,"Bicep":16.5,"Sleeve":25,"Length":29},"Shirt":{},"Trouser":{"Waist":40.5,"Hips":50.5,"Thigh":33,"Knee":20.5,"Bottom":14.5,"Length":40,"Crotch":33}}'::jsonb, 14000, 10000, 1, '2026-05-09 12:14:35.709+00', '', v_worker_22, '"[\"19\"]"'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_90, v_org_id, v_shop_id, v_manager_id, 'Wilfred Onchari', '0708295858', 'Kaunda/Senator Suit', '{"Top":{"Shoulder":19.5,"Sleeve":26,"Arm":13.5,"Chest":41.5,"Waist":33.5,"Length":31,"Neck":15.5},"Trouser":{"Waist":34.5,"Thigh":28,"Knee":17,"Bottom":14,"Length":42,"Crotch":29}}'::jsonb, 8500, 8500, 1, '2026-05-12 15:00:27.88+00', '', v_worker_18, '"[\"31\"]"'::jsonb);

-- 7. Import Payments
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_23, v_manager_id, 4000, 'cash', '', '2025-12-09 07:48:44.786+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_24, v_manager_id, 15000, 'cash', '', '2025-12-09 07:58:48.459+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_25, v_manager_id, 15000, 'cash', 'Admin Manual Entry', '2025-12-09 08:24:06.61+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_27, v_manager_id, 3500, 'cash', '', '2025-12-10 08:33:20.498+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_28, v_manager_id, 38000, 'cash', '', '2025-12-15 07:43:01.959+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_27, v_manager_id, 7000, 'cash', '7000', '2025-12-15 08:15:45.927+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_26, v_manager_id, 10500, 'cash', '10500', '2025-12-15 08:16:49.864+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_30, v_manager_id, 2500, 'cash', '', '2025-12-15 16:16:42.254+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_31, v_manager_id, 6000, 'cash', '', '2025-12-16 07:59:59.456+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_32, v_manager_id, 5000, 'cash', '', '2025-12-16 08:16:31.928+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_33, v_manager_id, 8000, 'cash', '', '2025-12-16 17:56:55.707+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_34, v_manager_id, 10000, 'cash', '', '2025-12-17 07:13:55.044+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_36, v_manager_id, 18500, 'cash', '', '2025-12-18 17:28:43.930538+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_25, v_manager_id, 15000, 'cash', 'Admin Manual Entry', '2025-12-19 08:00:49.251+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_37, v_manager_id, 16000, 'cash', '', '2025-12-19 08:28:06.398+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_32, v_manager_id, 11000, 'cash', '', '2025-12-19 08:37:04.131+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_32, v_manager_id, 11000, 'cash', '', '2025-12-19 08:37:37.586+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_32, v_manager_id, 11000, 'cash', '', '2025-12-19 08:39:33.113+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_23, v_manager_id, 2000, 'cash', '', '2025-12-19 08:52:03.239+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_39, v_manager_id, 5500, 'cash', '', '2025-12-19 09:11:11.792281+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_40, v_manager_id, 5500, 'cash', '', '2025-12-19 09:16:16.599044+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_41, v_manager_id, 10000, 'cash', '', '2026-01-05 09:42:13.637566+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_42, v_manager_id, 10000, 'cash', '', '2026-01-05 09:47:32.693+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_43, v_manager_id, 14000, 'cash', '', '2026-01-05 09:52:48.616287+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_44, v_manager_id, 10000, 'cash', '', '2026-01-05 09:57:40.253938+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_45, v_manager_id, 14000, 'cash', '', '2026-01-05 10:05:15.042644+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_23, v_manager_id, 2000, 'cash', '', '2026-01-05 10:47:32.664+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_30, v_manager_id, 4500, 'cash', '', '2026-01-05 10:50:44.326+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_46, v_manager_id, 10000, 'cash', '', '2026-01-06 12:59:59.755288+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_47, v_manager_id, 20000, 'cash', '', '2026-01-06 13:15:56.556228+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_48, v_manager_id, 8000, 'cash', '', '2026-02-16 05:38:32.027928+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_34, v_manager_id, 5500, 'cash', '', '2026-02-16 06:48:25.845+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_46, v_manager_id, 12000, 'cash', '', '2026-02-16 06:53:45.879+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_31, v_manager_id, 6000, 'cash', '', '2026-02-16 06:54:40.764+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_45, v_manager_id, 3000, 'cash', '', '2026-02-16 06:55:13.005+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_49, v_manager_id, 8000, 'cash', '', '2026-02-17 16:37:39.083511+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_50, v_manager_id, 16000, 'cash', '', '2026-02-17 16:41:23.785346+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_51, v_manager_id, 7000, 'cash', '', '2026-02-23 15:41:29.780336+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_52, v_manager_id, 15000, 'cash', '', '2026-02-23 15:51:33.50481+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_53, v_manager_id, 12000, 'cash', '', '2026-02-23 16:07:34.581883+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_58, v_manager_id, 40000, 'cash', '', '2026-02-27 14:05:24.639511+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_59, v_manager_id, 8000, 'cash', '', '2026-03-02 09:53:55.59621+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_60, v_manager_id, 10000, 'cash', '', '2026-03-02 10:03:22.093235+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_33, v_manager_id, 50000, 'cash', '', '2026-03-02 12:49:14.069+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_33, v_manager_id, 50000, 'cash', '', '2026-03-02 12:49:49.112+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_61, v_manager_id, 8400, 'cash', '', '2026-03-03 14:03:10.259236+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_49, v_manager_id, 9000, 'cash', '', '2026-03-10 16:20:16.342+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_61, v_manager_id, 5600, 'cash', '', '2026-03-10 16:28:20.314+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_58, v_manager_id, 20000, 'cash', '', '2026-03-10 16:45:27.847+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_51, v_manager_id, 7000, 'cash', '', '2026-03-10 16:48:56.241+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_53, v_manager_id, 12000, 'cash', '', '2026-03-10 16:50:01.249+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_63, v_manager_id, 8000, 'cash', '', '2026-03-11 06:41:59.73875+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_64, v_manager_id, 5000, 'cash', '', '2026-03-11 06:47:32.726638+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_65, v_manager_id, 5000, 'cash', '', '2026-03-11 06:53:06.16401+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_66, v_manager_id, 12500, 'cash', '', '2026-03-11 09:48:08.483828+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_67, v_manager_id, 8000, 'cash', '', '2026-03-11 10:03:32.929272+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_68, v_manager_id, 8000, 'cash', '', '2026-03-12 09:53:45.780793+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_69, v_manager_id, 5000, 'cash', '', '2026-03-12 10:37:18.04281+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_70, v_manager_id, 5000, 'cash', '', '2026-03-12 10:46:28.1634+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_71, v_manager_id, 3000, 'cash', '', '2026-03-12 10:59:11.160104+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_72, v_manager_id, 4000, 'cash', '', '2026-03-12 11:15:22.208886+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_48, v_manager_id, 8000, 'cash', '', '2026-03-12 11:23:05.777+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_73, v_manager_id, 14000, 'cash', '', '2026-03-13 08:42:47.152443+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_74, v_manager_id, 16000, 'cash', '', '2026-03-16 10:38:00.668996+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_75, v_manager_id, 11000, 'cash', '', '2026-03-16 11:16:36.070587+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_76, v_manager_id, 11000, 'cash', '', '2026-03-16 11:19:57.994159+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_77, v_manager_id, 10000, 'cash', '', '2026-03-24 17:47:13.29784+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_78, v_manager_id, 8000, 'cash', '', '2026-04-02 07:47:46.850468+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_80, v_manager_id, 3000, 'cash', '', '2026-04-02 07:56:09.539105+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_81, v_manager_id, 11000, 'cash', '', '2026-04-02 08:11:22.135643+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_82, v_manager_id, 4000, 'cash', '', '2026-04-02 08:28:23.363457+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_83, v_manager_id, 15000, 'cash', '', '2026-04-04 08:43:25.262574+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_84, v_manager_id, 4000, 'cash', '', '2026-04-10 11:22:42.273842+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_60, v_manager_id, 6000, 'cash', '', '2026-04-14 12:27:46.866+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_74, v_manager_id, 1000, 'cash', '', '2026-04-14 12:38:05.799+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_33, v_manager_id, 34000, 'cash', '', '2026-04-14 15:33:00.587+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_59, v_manager_id, 4000, 'cash', '', '2026-04-14 15:40:28.743+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_59, v_manager_id, 4000, 'cash', '', '2026-04-14 15:41:00.153+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_64, v_manager_id, 6000, 'cash', '', '2026-04-14 15:43:32.835+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_67, v_manager_id, 6000, 'cash', '', '2026-04-14 15:49:49.58+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_75, v_manager_id, 7000, 'cash', '', '2026-04-14 15:50:22.316+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_76, v_manager_id, 7000, 'cash', '', '2026-04-14 15:50:39.943+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_71, v_manager_id, 10000, 'cash', '', '2026-04-14 15:55:09.379+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_77, v_manager_id, 5000, 'cash', '', '2026-04-14 16:49:41.709+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_82, v_manager_id, 4000, 'cash', '', '2026-04-14 16:50:28.946+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_80, v_manager_id, 13000, 'cash', '', '2026-04-14 16:52:36.75+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_65, v_manager_id, 7000, 'cash', '', '2026-04-15 06:05:29.797+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_63, v_manager_id, 7000, 'cash', '', '2026-04-15 06:05:58.004+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_62, v_manager_id, 8000, 'cash', '', '2026-04-15 06:10:25.044+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_72, v_manager_id, 8000, 'cash', '', '2026-04-15 06:12:19.098+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_86, v_manager_id, 10000, 'cash', '', '2026-04-15 14:35:23.674836+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_87, v_manager_id, 20000, 'cash', '', '2026-04-20 08:21:32.842537+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_88, v_manager_id, 24000, 'cash', '', '2026-05-09 12:07:09.34261+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_89, v_manager_id, 10000, 'cash', '', '2026-05-09 12:14:36.797497+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_90, v_manager_id, 8500, 'cash', '', '2026-05-12 15:00:29.342061+00');

END $$;
