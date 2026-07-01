-- MIGRATION SCRIPT FOR PRETTY STITCHES AND APPAREL

DO $$
DECLARE
  v_org_id uuid := gen_random_uuid();
  v_manager_id uuid;
  v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea uuid := gen_random_uuid();
  v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67 uuid := gen_random_uuid();
  v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0 uuid := gen_random_uuid();
  v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d uuid := gen_random_uuid();
  v_client_084f0802_a8cb_4421_b455_c803ef312370 uuid := gen_random_uuid();
  v_client_088a9537_5d7d_491e_8ae7_6e179881ce65 uuid := gen_random_uuid();
  v_client_0a247e7a_0093_49ce_8a60_998b7a00344d uuid := gen_random_uuid();
  v_client_14645141_a52a_4bb5_8cbd_cf1e21c3485f uuid := gen_random_uuid();
  v_client_1492ab21_4ca5_4fa7_b57a_0ece25ed92ce uuid := gen_random_uuid();
  v_client_15d0a629_ab70_440c_8b94_ca1333ca599a uuid := gen_random_uuid();
  v_client_17d3495f_ba73_4c2e_88f2_9e9b7fc90366 uuid := gen_random_uuid();
  v_client_1c11efb0_8b04_4ba2_a7f2_dfb22b66027f uuid := gen_random_uuid();
  v_client_2637da6d_4eb9_4d0a_a4be_faa448f53ab6 uuid := gen_random_uuid();
  v_client_270e6252_090e_435c_88db_e6ffa846b445 uuid := gen_random_uuid();
  v_client_273469c6_a168_48b9_a826_47124cd560ea uuid := gen_random_uuid();
  v_client_279ac725_453f_4cef_95b1_a7a9f35dfd67 uuid := gen_random_uuid();
  v_client_2b548ae7_ec0f_4a78_82e2_f9a7f786e7cf uuid := gen_random_uuid();
  v_client_40b74c40_0aa9_47ca_829b_2f94ebda995b uuid := gen_random_uuid();
  v_client_417f7936_7c59_47bf_9594_5749faa2bb1e uuid := gen_random_uuid();
  v_client_45d3bf4f_75de_448b_a98d_55e7691f3bcd uuid := gen_random_uuid();
  v_client_4686f18e_dd18_4180_bf04_d77bd1352d8b uuid := gen_random_uuid();
  v_client_46ada19d_80f1_4597_9080_7365cb5290e7 uuid := gen_random_uuid();
  v_client_481818bb_4a48_4185_89d6_0cd98eb530c1 uuid := gen_random_uuid();
  v_client_4838e701_e667_4c0a_b076_d2b054501163 uuid := gen_random_uuid();
  v_client_49e0ed04_d218_4ac1_ac7d_c9e152e19a07 uuid := gen_random_uuid();
  v_client_4c16383e_819c_4465_bbe8_af643461c0fb uuid := gen_random_uuid();
  v_client_4dbf16b8_2127_467a_b39e_7288da398c2e uuid := gen_random_uuid();
  v_client_5172e0af_cf25_4c72_81bc_190e2f4f20a1 uuid := gen_random_uuid();
  v_client_548cc78e_5fca_4f98_95f0_687faa2b8e39 uuid := gen_random_uuid();
  v_client_57e8bf91_bac7_4e9d_92ca_cb7f5e878b86 uuid := gen_random_uuid();
  v_client_5b2cd878_4c19_4485_aa5b_92d9331c4939 uuid := gen_random_uuid();
  v_client_5c717ae6_8aa7_461d_8cd9_3a6cd842ecd5 uuid := gen_random_uuid();
  v_client_5e4c8e8c_ebf1_411e_964b_1f6a2e0b75c6 uuid := gen_random_uuid();
  v_client_625c9fb1_40d5_4b83_adff_85aef2bed245 uuid := gen_random_uuid();
  v_client_6596e55e_692a_4940_826d_d1656ec9572d uuid := gen_random_uuid();
  v_client_659b39cc_9184_42e9_af83_8e3c7fcfddc7 uuid := gen_random_uuid();
  v_client_68a9a0ca_b2f4_4262_ba04_0d858262548f uuid := gen_random_uuid();
  v_client_699e1ba6_612d_4709_a1b9_8f851e673c78 uuid := gen_random_uuid();
  v_client_6e4ce4bd_3b89_45ad_8f50_aa1ae8731432 uuid := gen_random_uuid();
  v_client_6effee79_b9b2_4c77_b487_80874d23046a uuid := gen_random_uuid();
  v_client_714ffed1_5bf0_4835_92d4_5e4da2c5ffe3 uuid := gen_random_uuid();
  v_client_7170249d_356f_4587_a409_b0b6a35ea7c2 uuid := gen_random_uuid();
  v_client_769449eb_1619_4673_9287_07352c4e9cb7 uuid := gen_random_uuid();
  v_client_78228d75_9259_4858_a480_b36330f144fc uuid := gen_random_uuid();
  v_client_800c52ed_502c_4a19_acd3_9794cc43c939 uuid := gen_random_uuid();
  v_client_810c8a69_7b3e_4a62_97ea_ad3dd077cd6b uuid := gen_random_uuid();
  v_client_82bb6b03_c548_43fc_a266_cab7e6a54b80 uuid := gen_random_uuid();
  v_client_85f19841_2cab_4dad_aaf9_30c6c03e0875 uuid := gen_random_uuid();
  v_client_880ffcea_f7a4_48e0_a441_b17ef212c105 uuid := gen_random_uuid();
  v_client_8c63110a_5407_47c8_8a70_41e005e458fc uuid := gen_random_uuid();
  v_client_8d36befc_e69d_430c_bb51_f83316896c74 uuid := gen_random_uuid();
  v_client_97424971_57f1_46c1_aacc_9583645fc1a1 uuid := gen_random_uuid();
  v_client_9caa9548_bbd0_4ec5_af2e_90cc7b486e56 uuid := gen_random_uuid();
  v_client_9ebc8f96_07ce_4e34_b42d_1a714d2366c5 uuid := gen_random_uuid();
  v_client_a3fed2be_5eac_4380_bb89_31320ac954c6 uuid := gen_random_uuid();
  v_client_aade0e7d_3516_4ccf_988b_aa14ea7ac46b uuid := gen_random_uuid();
  v_client_ac1c636a_ef54_4446_8b4b_8d5ca3e03920 uuid := gen_random_uuid();
  v_client_afa88355_c935_4923_abf3_2c14324242ef uuid := gen_random_uuid();
  v_client_afaa2f34_d1d0_499f_a64c_94453f5ab3f4 uuid := gen_random_uuid();
  v_client_b5af2bd0_fad7_4a85_9e50_9ec3a0f71f82 uuid := gen_random_uuid();
  v_client_b60c0e39_9144_4fc7_a2e8_0e7671e8a345 uuid := gen_random_uuid();
  v_client_bbee2bb5_9bf5_4a08_bd62_6726ad307d67 uuid := gen_random_uuid();
  v_client_bcbb4d5a_c947_4e36_8137_bf876d94bdb2 uuid := gen_random_uuid();
  v_client_bd1b3076_ca92_454c_b4b6_220f7caa6267 uuid := gen_random_uuid();
  v_client_bebeb9fe_47e3_487f_8596_135f47adf77a uuid := gen_random_uuid();
  v_client_bf03d84f_a5f1_4f72_a219_493e7288da69 uuid := gen_random_uuid();
  v_client_c500c02a_0155_4db9_b627_8f0bbcca4e4b uuid := gen_random_uuid();
  v_client_cfb18d8e_f0c0_49b9_be35_c5ca40bb501b uuid := gen_random_uuid();
  v_client_d01c519b_26b7_4e09_b32c_85a32b79c8ea uuid := gen_random_uuid();
  v_client_e328dfc1_765b_4042_b5c4_4549abe9d572 uuid := gen_random_uuid();
  v_client_e62afcd1_d6e5_4e4f_b34c_1882870a3317 uuid := gen_random_uuid();
  v_client_ea0d5eeb_9c45_41ff_875e_6fa2ff2a7e56 uuid := gen_random_uuid();
  v_client_ef25dffb_9d23_46e6_9634_8775d1cc96e7 uuid := gen_random_uuid();
  v_client_f456b44f_65b0_40a5_8fd6_1b8bdf881f89 uuid := gen_random_uuid();
  v_client_f7707435_b987_4373_8229_f2a784f16bb7 uuid := gen_random_uuid();
  v_client_fbdda284_3718_46ac_a845_a4fca1e3e3e8 uuid := gen_random_uuid();
  v_order_0076ad32_0554_44c2_a97e_d14d4bd1fa58 uuid := gen_random_uuid();
  v_order_00c6872a_7934_41ae_8ced_2e44bdf151db uuid := gen_random_uuid();
  v_order_02801f54_cdac_4bec_b732_13a41ae6ccca uuid := gen_random_uuid();
  v_order_0298153c_9662_4865_97f3_7baeec6f1a70 uuid := gen_random_uuid();
  v_order_035a0b87_5e0a_4747_ab10_096701774729 uuid := gen_random_uuid();
  v_order_04ac11e0_f980_430f_b891_ef0c764c4c6e uuid := gen_random_uuid();
  v_order_054e15de_3733_4e03_99b2_a994b362f130 uuid := gen_random_uuid();
  v_order_05cd7b36_cbee_4fa3_aed9_bfbc42d61c6e uuid := gen_random_uuid();
  v_order_05f7acc6_8526_422c_88d8_bb7d94da23c6 uuid := gen_random_uuid();
  v_order_0607675f_fb89_4c83_b7c7_919d9e426eee uuid := gen_random_uuid();
  v_order_0626eac1_6293_4418_bafc_41a8daeffa3c uuid := gen_random_uuid();
  v_order_0721cbd0_fb36_4b2e_9c25_3931c8e11c9b uuid := gen_random_uuid();
  v_order_079030b9_cd99_434b_8980_c536f1fbff82 uuid := gen_random_uuid();
  v_order_07f19229_c185_4a64_a8f1_6fdd69245e36 uuid := gen_random_uuid();
  v_order_08091250_d494_443e_b419_a28e349bdef4 uuid := gen_random_uuid();
  v_order_0ababa08_aa34_4744_b19a_853ffaa48a3a uuid := gen_random_uuid();
  v_order_0abaebaf_0c19_4a3b_876e_3c7787bf39c0 uuid := gen_random_uuid();
  v_order_0b627b54_94b8_4a99_ade6_339762265279 uuid := gen_random_uuid();
  v_order_0b790c27_d52f_49d5_bac1_b388e6d1eeeb uuid := gen_random_uuid();
  v_order_0c8af382_4867_46ea_a8fb_c83038b4d021 uuid := gen_random_uuid();
  v_order_0d0aa9c4_adc2_4aae_92a0_b3b044e9e02e uuid := gen_random_uuid();
  v_order_0d103666_3eaa_43c1_9dac_2c7a3e038426 uuid := gen_random_uuid();
  v_order_0e3b02c2_94fa_47fd_aa09_2d2f3d52336e uuid := gen_random_uuid();
  v_order_0e9eb187_a964_4ff0_b11b_763b66f5310a uuid := gen_random_uuid();
  v_order_0f09c1a7_4295_4a4b_94bc_70fbdb5b0807 uuid := gen_random_uuid();
  v_order_105b4470_aad5_4220_a3bb_2913fcff7fb5 uuid := gen_random_uuid();
  v_order_10985031_5124_4519_b293_5e38a42f79f3 uuid := gen_random_uuid();
  v_order_1194f579_8390_42a9_baf1_a9556923eb70 uuid := gen_random_uuid();
  v_order_1198ce1c_36b8_4230_9a2b_633ff3a34485 uuid := gen_random_uuid();
  v_order_12819aa5_d08a_42ac_bf04_89bb07d2b9ed uuid := gen_random_uuid();
  v_order_13095957_37e4_4868_b240_4041465dbe55 uuid := gen_random_uuid();
  v_order_13243e03_5e09_4024_a21f_e8ed1233323b uuid := gen_random_uuid();
  v_order_1390ef8a_e13b_40bb_89a7_c536cbbf323c uuid := gen_random_uuid();
  v_order_13f238bf_d58d_4fed_981d_2aef763d292b uuid := gen_random_uuid();
  v_order_17e43ff7_f45d_4b4a_83d5_66f5558b176a uuid := gen_random_uuid();
  v_order_17f1a5f1_0f0b_4629_82a7_4926ce3440af uuid := gen_random_uuid();
  v_order_18b284f3_3738_4f9c_b05c_02a863e1a06a uuid := gen_random_uuid();
  v_order_19781198_57d6_42d0_ac22_3c7ab36b0172 uuid := gen_random_uuid();
  v_order_1a363481_e9c7_45d2_b673_e806842a6d25 uuid := gen_random_uuid();
  v_order_1f113fa4_caad_4027_b97e_e0538dd372e9 uuid := gen_random_uuid();
  v_order_211ddf87_cbc7_4b08_a9f8_5c016a1ac3df uuid := gen_random_uuid();
  v_order_22186ffa_a0c1_42f7_8551_031ef5e36a51 uuid := gen_random_uuid();
  v_order_229ce27a_279c_45e7_acce_e657728c7771 uuid := gen_random_uuid();
  v_order_23a7aa01_71bf_4ac6_8ad0_885138422b5b uuid := gen_random_uuid();
  v_order_23c08a40_0585_4137_9418_64379817de46 uuid := gen_random_uuid();
  v_order_2567af9f_3253_4ab1_80c7_cffe58c6653f uuid := gen_random_uuid();
  v_order_25c9d6c3_f731_4764_8970_126f278cf204 uuid := gen_random_uuid();
  v_order_26560755_83c8_4d76_a7e1_c07f7f97e3b9 uuid := gen_random_uuid();
  v_order_286f7ca0_c98b_4946_9ac3_9b29b57f41bf uuid := gen_random_uuid();
  v_order_289382f2_fff3_413d_8709_b19fbbffe488 uuid := gen_random_uuid();
  v_order_29842f94_1ad9_4bdb_bd71_7299953026a7 uuid := gen_random_uuid();
  v_order_29bd86d7_611d_41ab_bd1e_9b9fc41d5797 uuid := gen_random_uuid();
  v_order_2a01f1d7_4a6d_4389_a151_47b2c25403e2 uuid := gen_random_uuid();
  v_order_2a87202c_0ed1_4da5_a8d1_b62219ac9a52 uuid := gen_random_uuid();
  v_order_2b490617_11c3_4aa7_857f_ec9437354b60 uuid := gen_random_uuid();
  v_order_2bad0435_1614_44f1_a73b_85b99e47d913 uuid := gen_random_uuid();
  v_order_2d2cde47_49a7_4c24_b4f7_a8091ff2c599 uuid := gen_random_uuid();
  v_order_2edc0c90_0ddd_44ec_9bd8_39ed5d739dbd uuid := gen_random_uuid();
  v_order_2fb322cd_1418_4839_a3f7_5ae44026781a uuid := gen_random_uuid();
  v_order_30f41e72_1c85_459a_b005_1767dfd1203e uuid := gen_random_uuid();
  v_order_311299d8_f229_49e1_8122_ef4d74dbea85 uuid := gen_random_uuid();
  v_order_31c73b06_7406_42a1_b392_413fce055657 uuid := gen_random_uuid();
  v_order_32971693_a74c_4d48_a189_fd079dba1aa6 uuid := gen_random_uuid();
  v_order_3387c183_ffb3_46b6_a7a3_d03bb748da5c uuid := gen_random_uuid();
  v_order_33b19d16_8b05_494e_9787_66b53b65930e uuid := gen_random_uuid();
  v_order_3448b53b_7832_4136_903d_554c40f9267d uuid := gen_random_uuid();
  v_order_3482afba_01bc_4a9d_acda_11a75f11148a uuid := gen_random_uuid();
  v_order_34ede3e6_03ad_4998_a845_4e956d4049ac uuid := gen_random_uuid();
  v_order_353a301d_6989_451a_865f_a075708768ce uuid := gen_random_uuid();
  v_order_36964c97_250e_4d1c_867b_072f52b1ef1a uuid := gen_random_uuid();
  v_order_375a3d1b_b606_4907_bae7_1924e2493034 uuid := gen_random_uuid();
  v_order_376209e8_9c96_41be_a0bc_28dd883cc40a uuid := gen_random_uuid();
  v_order_37a9d214_5b59_4dc3_8002_cc842a7d59da uuid := gen_random_uuid();
  v_order_37ba72c1_8280_4b59_9cd9_ba6c9e1eab28 uuid := gen_random_uuid();
  v_order_38aa44a8_4682_4980_a838_3b305615dcbf uuid := gen_random_uuid();
  v_order_3997f029_23d9_4ab0_8b52_ee512bffe7ac uuid := gen_random_uuid();
  v_order_3b7785cf_2fed_4b3c_8c6b_def1f3acc699 uuid := gen_random_uuid();
  v_order_3bc18eda_fcbf_4f54_a3cd_47d1af2b1e27 uuid := gen_random_uuid();
  v_order_3bc9e832_f5a4_401d_8fa5_f3b60019ec13 uuid := gen_random_uuid();
  v_order_3cbc6279_7bfb_42fa_b8d5_5d44346f11d6 uuid := gen_random_uuid();
  v_order_3e396821_be2d_43f7_8a71_677ce1a442f9 uuid := gen_random_uuid();
  v_order_3f02ebe6_f3cd_4341_b825_d392e5abdbe0 uuid := gen_random_uuid();
  v_order_3f4313e9_07b6_4c8f_be4b_f49cba1b2872 uuid := gen_random_uuid();
  v_order_3f4990d9_d1bf_4f4d_865c_72c50d27bb10 uuid := gen_random_uuid();
  v_order_3fee883f_f1d0_487d_8d23_1abac51bf70d uuid := gen_random_uuid();
  v_order_3fef6309_97f9_4786_ab66_734ce3fd7d7e uuid := gen_random_uuid();
  v_order_41ad28d3_28e0_4d62_832e_d8fffdb4a847 uuid := gen_random_uuid();
  v_order_41b0f602_b136_4702_a000_f96a51a77693 uuid := gen_random_uuid();
  v_order_425f4714_ca96_417d_af0f_c98af89abf59 uuid := gen_random_uuid();
  v_order_429ea2fa_65a0_4e0c_a828_f64d9e02acd5 uuid := gen_random_uuid();
  v_order_437b69fd_69ed_4ddb_ad56_4e22e0ee49a4 uuid := gen_random_uuid();
  v_order_4391054d_3169_49ab_b62b_7f75f3f534aa uuid := gen_random_uuid();
  v_order_4405f45e_9552_4e65_bb2b_ecee6b36d025 uuid := gen_random_uuid();
  v_order_443fcf26_babc_4086_9c05_fcc004b9f926 uuid := gen_random_uuid();
  v_order_46858bdb_80ad_45d0_8a7d_f2423052b76e uuid := gen_random_uuid();
  v_order_471f49e8_14d8_411a_a83f_0e403595b815 uuid := gen_random_uuid();
  v_order_4851c661_1070_4925_b930_685d6c80aa20 uuid := gen_random_uuid();
  v_order_48c2ed03_5414_4c24_9857_a8ed17c044df uuid := gen_random_uuid();
  v_order_4989e9bb_d092_47a8_9760_37eec9dff252 uuid := gen_random_uuid();
  v_order_49da75db_91a6_4ef8_9009_1899e32178f8 uuid := gen_random_uuid();
  v_order_4d908ed0_f0c3_48c5_b88e_56428ec77fe9 uuid := gen_random_uuid();
  v_order_4f842ed5_049c_4760_a148_0f6e7a9fd388 uuid := gen_random_uuid();
  v_order_4fbe841d_1e68_40e8_9a81_8701dbcbaecb uuid := gen_random_uuid();
  v_order_4fe15d4e_ee02_45b3_9801_9af35c27570e uuid := gen_random_uuid();
  v_order_52161fcb_317a_41e1_9f97_70261385b36c uuid := gen_random_uuid();
  v_order_528677f0_99bd_4ff0_b7dd_df2d6b7b6188 uuid := gen_random_uuid();
  v_order_52901161_b017_4eea_aef9_618f84b7e545 uuid := gen_random_uuid();
  v_order_53dbdaee_db5d_41a2_b0f4_f0bcf3be1d83 uuid := gen_random_uuid();
  v_order_5412c8fb_9740_4aaf_95d2_b6c3ec621a07 uuid := gen_random_uuid();
  v_order_5454e22a_821a_44e9_afa4_07828b06a00b uuid := gen_random_uuid();
  v_order_55aacc69_68c7_48d8_a662_f25b0b03ce49 uuid := gen_random_uuid();
  v_order_55e127ad_33e3_4e8b_a119_f3a0db1c5fd4 uuid := gen_random_uuid();
  v_order_5697b913_2fb0_4559_ba97_430a7c7f56ca uuid := gen_random_uuid();
  v_order_56c5cca7_5e8e_4216_bc03_a50bbc6178d9 uuid := gen_random_uuid();
  v_order_5706a438_9448_4283_9e93_9d03d3487387 uuid := gen_random_uuid();
  v_order_57d1fa50_51df_4c56_af97_fe657f6db46a uuid := gen_random_uuid();
  v_order_58387986_c2f4_48fb_9721_cc90a4936c05 uuid := gen_random_uuid();
  v_order_5983e0fc_5714_44d8_b90d_8e3b530e212b uuid := gen_random_uuid();
  v_order_5add4268_e2cd_4f2c_9f9a_57d673d222bf uuid := gen_random_uuid();
  v_order_5b114319_7218_415b_9f72_7aeeb66b64fd uuid := gen_random_uuid();
  v_order_5b15bc02_0ac0_435d_9843_0a93b1faa926 uuid := gen_random_uuid();
  v_order_5b487d29_8d17_4973_a4ba_7070366941e3 uuid := gen_random_uuid();
  v_order_5c5d5520_c83e_4249_8022_58094bf80794 uuid := gen_random_uuid();
  v_order_5cd9aea2_4ce0_4681_a00d_10b4e6820a98 uuid := gen_random_uuid();
  v_order_5cde6ba5_95c7_4df0_a8e2_56b8ec4d0081 uuid := gen_random_uuid();
  v_order_5dd8d2cd_ef81_4494_9caf_05555ba210c0 uuid := gen_random_uuid();
  v_order_60013079_a55d_4155_8e3b_af2da332ced8 uuid := gen_random_uuid();
  v_order_612281e1_040d_409c_9a73_75e55a831601 uuid := gen_random_uuid();
  v_order_6183e2ec_e0bd_4b32_995e_a60d46116da6 uuid := gen_random_uuid();
  v_order_61860dd4_8965_4fef_aeb3_2a63dbb15d03 uuid := gen_random_uuid();
  v_order_61e1dc0e_95b1_4631_bfe0_140cb723735d uuid := gen_random_uuid();
  v_order_62434a1b_0461_461b_a378_53c38af5ba05 uuid := gen_random_uuid();
  v_order_625dca75_715a_42dc_a5d1_8633048ec197 uuid := gen_random_uuid();
  v_order_660eea38_841a_4654_a857_49b6739eb674 uuid := gen_random_uuid();
  v_order_66378964_5e20_49cf_b146_f5001352ef45 uuid := gen_random_uuid();
  v_order_66b0ea02_73db_43f3_9566_6304c75c95e6 uuid := gen_random_uuid();
  v_order_6799485b_6976_4e50_9e5f_54c614b2895a uuid := gen_random_uuid();
  v_order_691595ad_1436_49da_8d21_fd9468670b75 uuid := gen_random_uuid();
  v_order_6b15494f_fdeb_4e2c_83b2_e116ce746359 uuid := gen_random_uuid();
  v_order_6b1cafef_9ca9_46d4_bbab_df852c9936e4 uuid := gen_random_uuid();
  v_order_6bd1b009_afde_471b_9a0a_5e5e4dc5f72d uuid := gen_random_uuid();
  v_order_6c3e54a1_1270_4ad5_9839_ab5ab310b98d uuid := gen_random_uuid();
  v_order_6d7e80df_88e8_4f9f_a575_eb73b16b188e uuid := gen_random_uuid();
  v_order_6e9a3b25_b507_4ce7_a7b6_90033b854f47 uuid := gen_random_uuid();
  v_order_6ea0e5ce_0ecb_49ef_9248_0ab6ba1e5f01 uuid := gen_random_uuid();
  v_order_6ed7640a_c3a0_432b_856a_ca63feddcc67 uuid := gen_random_uuid();
  v_order_6f830b7b_295e_4e46_bf1c_050eb8d343f3 uuid := gen_random_uuid();
  v_order_709dec22_5a7c_43d4_b477_0633488b1ecc uuid := gen_random_uuid();
  v_order_70a9b8ef_090e_48a3_926e_ef8f44a597b0 uuid := gen_random_uuid();
  v_order_71c540ea_44f7_4e7a_ab20_a2d025ab3182 uuid := gen_random_uuid();
  v_order_72f9a4b6_3777_411e_8309_27b7f3a4f996 uuid := gen_random_uuid();
  v_order_73c4746c_db36_44c2_89b1_fef3ed896943 uuid := gen_random_uuid();
  v_order_77c255a0_3976_437b_8615_da325d350b88 uuid := gen_random_uuid();
  v_order_77e81e1a_1aff_4da0_9137_2c3562b244bc uuid := gen_random_uuid();
  v_order_781de23c_a86c_48d1_bba6_71fe51a72ed6 uuid := gen_random_uuid();
  v_order_7824a73a_3de9_4719_a37e_3e4b8c370cb5 uuid := gen_random_uuid();
  v_order_78406b3d_c539_4ff2_aa63_d645c8484110 uuid := gen_random_uuid();
  v_order_78844f7c_db9e_403d_9167_727a35e4e7c9 uuid := gen_random_uuid();
  v_order_78868fc0_7111_4df4_aaa8_98e98c830f29 uuid := gen_random_uuid();
  v_order_78cdf8e7_2542_4cfa_b99a_0fb574a5bf10 uuid := gen_random_uuid();
  v_order_79e4949a_2daa_46cb_b4e4_0761605c1be2 uuid := gen_random_uuid();
  v_order_7b0575ca_e267_4e88_8b40_05fd387fdb35 uuid := gen_random_uuid();
  v_order_7b83db63_5fbc_4d0e_9c4c_718a38a89ff8 uuid := gen_random_uuid();
  v_order_7c46a2dc_ea73_4490_bcb2_1820d12c4a00 uuid := gen_random_uuid();
  v_order_7c584062_600d_426f_b6fb_dfe4f3019af6 uuid := gen_random_uuid();
  v_order_7c5d3448_fa66_4a5c_bf36_1e6bb02f6816 uuid := gen_random_uuid();
  v_order_7cd6c67b_7f77_4f33_878f_34d083f3d4a0 uuid := gen_random_uuid();
  v_order_7f6b6bbc_2106_49d4_9514_326c22273f8c uuid := gen_random_uuid();
  v_order_804a16a7_1633_4e07_b3c3_7a54b7353ab0 uuid := gen_random_uuid();
  v_order_80de5f40_2116_4c13_91fe_b4e36f63e827 uuid := gen_random_uuid();
  v_order_81588e07_d811_411c_bd76_e0c0241f5502 uuid := gen_random_uuid();
  v_order_8261b4d3_9c5a_4a02_ac60_55338eebbe92 uuid := gen_random_uuid();
  v_order_82b93d86_6cb4_4d7b_a7d9_ba7bf284e29d uuid := gen_random_uuid();
  v_order_82df5a29_2b2b_4d88_b3ff_c51eb6bd4f9f uuid := gen_random_uuid();
  v_order_82f59488_fd69_4905_ba60_5d33795556d0 uuid := gen_random_uuid();
  v_order_8521ee7e_4b34_4ff3_a4d9_f5f8fd3a874d uuid := gen_random_uuid();
  v_order_8544e6c6_ba3f_4da3_94a0_9e0dc55eae34 uuid := gen_random_uuid();
  v_order_858aa9c0_3417_44c5_8ced_1228e1add8aa uuid := gen_random_uuid();
  v_order_868c6bd5_126b_496f_9a24_705aae5adc14 uuid := gen_random_uuid();
  v_order_88c99709_07da_47d8_9976_71e776424619 uuid := gen_random_uuid();
  v_order_88f41f16_f715_4575_9f95_dd0685dfd8eb uuid := gen_random_uuid();
  v_order_8950f0ae_c2f1_4030_a24a_504aae3a7fb5 uuid := gen_random_uuid();
  v_order_89b59b57_aa1b_4ee7_9edc_bf580b89b3db uuid := gen_random_uuid();
  v_order_8a5e9bf5_9f1f_4230_93bd_1ce79c06f092 uuid := gen_random_uuid();
  v_order_8d19aef8_85dd_4b19_b358_9661f224b12b uuid := gen_random_uuid();
  v_order_8d3f6d93_8b43_45cb_8ee2_261fcda8d7a6 uuid := gen_random_uuid();
  v_order_8d7a8a39_3bbf_46f0_8db8_6399b0419819 uuid := gen_random_uuid();
  v_order_8d7f8b0f_e3e8_47ec_be33_4827e10673db uuid := gen_random_uuid();
  v_order_8e4e60a5_2027_4a84_9271_635b2347da03 uuid := gen_random_uuid();
  v_order_8f6f90d1_71e3_41d1_94cf_8380f293a753 uuid := gen_random_uuid();
  v_order_911d4d60_e960_4dcd_9438_2fd16672fe2d uuid := gen_random_uuid();
  v_order_9122c1d8_94ef_4e6d_af48_41aa9298a366 uuid := gen_random_uuid();
  v_order_92ecfbdb_2247_4938_8a3e_c55e724e13b9 uuid := gen_random_uuid();
  v_order_92f372aa_48ad_4fed_944c_055b78d476cf uuid := gen_random_uuid();
  v_order_9604b4e7_c559_47dc_9ec4_0c3224c0586e uuid := gen_random_uuid();
  v_order_9647382e_e309_432e_9bb4_d98c089da0ae uuid := gen_random_uuid();
  v_order_9682092d_8b58_47cc_b8e7_9b3a0a2048a6 uuid := gen_random_uuid();
  v_order_97d156f9_3973_4190_95c2_3e3ef95f9d2c uuid := gen_random_uuid();
  v_order_97daf4f4_7475_46c4_a3eb_a1c13706b4ef uuid := gen_random_uuid();
  v_order_9886f983_4d56_4046_9382_cd8faa01bf5c uuid := gen_random_uuid();
  v_order_9907dec6_d185_4f60_a32e_04f8f99383cc uuid := gen_random_uuid();
  v_order_991ded7f_c47d_457b_977a_75f06f924164 uuid := gen_random_uuid();
  v_order_99259c02_9c66_4ba9_b3ad_d84d18fe8e3f uuid := gen_random_uuid();
  v_order_9b99394f_dcb3_478d_965d_8964f9b52fee uuid := gen_random_uuid();
  v_order_9be5eead_6777_4870_b0bf_6ed9a569d97f uuid := gen_random_uuid();
  v_order_9d7f62ce_c8e5_486d_8022_f9f7a402e7e9 uuid := gen_random_uuid();
  v_order_9da98588_ec9b_4022_9126_eb706555892b uuid := gen_random_uuid();
  v_order_9ddf5337_f404_4499_8297_9f4e22346934 uuid := gen_random_uuid();
  v_order_9f1a3225_c288_46dd_bea8_fc03f9ded09f uuid := gen_random_uuid();
  v_order_9f804260_235b_4866_bceb_9e0854b41bfa uuid := gen_random_uuid();
  v_order_a1f6cc5a_b6ff_4bc4_9a2a_7c4a0cf14dd0 uuid := gen_random_uuid();
  v_order_a28626e1_b94e_4dc2_a840_ba6a2e553b52 uuid := gen_random_uuid();
  v_order_a37e94b7_4cce_432f_b938_782fe963a7eb uuid := gen_random_uuid();
  v_order_a3cc2eed_d392_4e5f_be80_43951e812cba uuid := gen_random_uuid();
  v_order_a3fb828b_7ca8_4d33_b6a7_c1c4b403ec2e uuid := gen_random_uuid();
  v_order_a40235af_9568_4d59_9ead_9cd613a6c9f2 uuid := gen_random_uuid();
  v_order_a47bd80b_1ae8_4572_986c_8b39290b45c4 uuid := gen_random_uuid();
  v_order_a4f09ca1_5b41_419f_ab29_c74d830d0cc9 uuid := gen_random_uuid();
  v_order_a4f38966_f52e_4828_9fad_27ba98864fc5 uuid := gen_random_uuid();
  v_order_a53fa1bf_5d85_4dbb_8d49_e02f709520f5 uuid := gen_random_uuid();
  v_order_a6a22c6b_6bec_44a9_b342_1abf4094591a uuid := gen_random_uuid();
  v_order_a805c5d3_c331_4165_b3e4_6f8a013e1622 uuid := gen_random_uuid();
  v_order_a9368b86_daef_418c_985b_14b8ef8be401 uuid := gen_random_uuid();
  v_order_a97db74f_f2ed_46cc_aae9_7b4661cd79cb uuid := gen_random_uuid();
  v_order_aa319382_afe7_4500_afa3_53c1072264cd uuid := gen_random_uuid();
  v_order_ab0d4683_d837_495a_8c13_bd9c6f09855e uuid := gen_random_uuid();
  v_order_ac11b3b2_536a_4fa0_a59c_10245558fa35 uuid := gen_random_uuid();
  v_order_ac8c5685_79b7_4431_bcb6_b8bbe2a5ef01 uuid := gen_random_uuid();
  v_order_accba925_dd84_42dd_9e95_4d427cfc0ff7 uuid := gen_random_uuid();
  v_order_adfd2172_08cc_4db6_a736_abac7938d514 uuid := gen_random_uuid();
  v_order_ae1f8f0c_7d64_473c_afd4_a2d5f031cce2 uuid := gen_random_uuid();
  v_order_aeb95683_91f5_49e2_adf9_f4314ff556dc uuid := gen_random_uuid();
  v_order_aece34a9_9104_4573_9f65_985141f19357 uuid := gen_random_uuid();
  v_order_aefbd269_d04d_4399_87ea_a8fe803e89dd uuid := gen_random_uuid();
  v_order_af0ee547_3c32_4039_bbf7_2c892f312963 uuid := gen_random_uuid();
  v_order_af476951_900f_4d9c_822f_d94015053f71 uuid := gen_random_uuid();
  v_order_b07eea9b_b3ac_48fa_93a0_e4671ca500b5 uuid := gen_random_uuid();
  v_order_b0c23acf_2622_4fde_81de_793d8e524a7d uuid := gen_random_uuid();
  v_order_b106bf8a_f444_497e_9a28_e51c0584de02 uuid := gen_random_uuid();
  v_order_b19018d6_fe68_4d0b_bf33_49fe7dbc2a17 uuid := gen_random_uuid();
  v_order_b47e1c5e_ded4_482e_8068_fe426bd62aad uuid := gen_random_uuid();
  v_order_b6bb2e2b_a9e6_4cef_87f2_318839f642d3 uuid := gen_random_uuid();
  v_order_b6e3899c_1998_4527_8aa0_d70b3256c0e7 uuid := gen_random_uuid();
  v_order_b7705875_6b63_4e62_9151_f1ceef5b92e7 uuid := gen_random_uuid();
  v_order_b78cf955_d66d_42d6_be32_0a267057e913 uuid := gen_random_uuid();
  v_order_b7b011f3_f616_48ba_8bd4_7f1c0984517f uuid := gen_random_uuid();
  v_order_b9d668b9_9762_48a0_9024_78113c559347 uuid := gen_random_uuid();
  v_order_bb1c9fe9_9aa1_4b6c_9a57_c54576ed3e14 uuid := gen_random_uuid();
  v_order_bb35a857_08f1_41e3_a121_2440680ddd88 uuid := gen_random_uuid();
  v_order_bb8fd263_323a_4762_85f2_964a69a3f9fa uuid := gen_random_uuid();
  v_order_bc73605a_df11_49ee_bc70_b23c8a193f00 uuid := gen_random_uuid();
  v_order_bdee4006_4124_4e6e_8217_dd20d8b98700 uuid := gen_random_uuid();
  v_order_be6f8d55_c5d7_44f9_b0fe_5201a3b3bbf0 uuid := gen_random_uuid();
  v_order_bf43df83_504a_4e4c_a028_92cc2eff10e7 uuid := gen_random_uuid();
  v_order_c02ea85e_e8e1_40a4_b2ab_f8850044d54c uuid := gen_random_uuid();
  v_order_c0492aab_e819_4d8a_92fa_363554f590e0 uuid := gen_random_uuid();
  v_order_c04c4f89_b82e_4145_a8ed_9fd36e808551 uuid := gen_random_uuid();
  v_order_c145b544_232b_4c08_926f_e054a68647df uuid := gen_random_uuid();
  v_order_c4100220_789a_4861_bb1a_d7d7ddca83cc uuid := gen_random_uuid();
  v_order_c45bbf5f_b432_4912_af20_d15a24cfcec6 uuid := gen_random_uuid();
  v_order_c5455c86_d08c_433f_a864_03465bc82262 uuid := gen_random_uuid();
  v_order_c61f3fd4_49c5_499d_b26a_1333637d8c82 uuid := gen_random_uuid();
  v_order_c7b05f3f_351b_4020_85d3_c3599362d243 uuid := gen_random_uuid();
  v_order_c9867a7f_463c_4172_b188_e7c396d5f791 uuid := gen_random_uuid();
  v_order_cc1ff338_f6bd_4a87_8d94_1e131a7ca25e uuid := gen_random_uuid();
  v_order_cf92d330_89d8_4ea4_9b9d_222a91f522cc uuid := gen_random_uuid();
  v_order_cf934039_36d0_44cc_a76e_0e76ae15ee04 uuid := gen_random_uuid();
  v_order_d09c6c70_cf9a_4e8a_a26b_0416cb01e121 uuid := gen_random_uuid();
  v_order_d2a6c846_4ad7_4b9a_9a5a_3fc8f56fed1a uuid := gen_random_uuid();
  v_order_d2cd0697_9374_41de_b487_b926fa687c63 uuid := gen_random_uuid();
  v_order_d2f81793_c3a4_475d_8c08_331bb0036ebd uuid := gen_random_uuid();
  v_order_d3773cfd_58b3_46ce_b3ef_813c2043608e uuid := gen_random_uuid();
  v_order_d389befa_eb54_4248_9683_d9bbc109fcfb uuid := gen_random_uuid();
  v_order_d38bbc6e_cc01_4c79_8f44_f1febbd767dd uuid := gen_random_uuid();
  v_order_d4079abd_86f7_4b24_85ff_b71e5b4ed5ad uuid := gen_random_uuid();
  v_order_d58b52d9_9f36_49b2_afdf_6c326413a8e0 uuid := gen_random_uuid();
  v_order_d617c6f0_1cbc_4ab4_afa5_db3e1cf24c62 uuid := gen_random_uuid();
  v_order_d73d75ff_8345_4c4d_9d2b_3d7e4dba0ae8 uuid := gen_random_uuid();
  v_order_d7b2547d_4563_4ec0_b43d_c9b2ce46aa38 uuid := gen_random_uuid();
  v_order_d7f2515f_2fc7_4690_8f46_d18a13f0b2eb uuid := gen_random_uuid();
  v_order_d8a7d739_4d2b_4de5_9bd7_2af5132502bf uuid := gen_random_uuid();
  v_order_d8abce89_d595_4c52_b92a_6dfaf9cf407d uuid := gen_random_uuid();
  v_order_d934c8a7_42ca_472d_b70b_70631e7bce0f uuid := gen_random_uuid();
  v_order_d9d70c11_c607_4bcd_ab38_c0159d56b14a uuid := gen_random_uuid();
  v_order_da0b50a1_679d_4598_9598_0dfcc381f733 uuid := gen_random_uuid();
  v_order_da1645e8_ab69_44a3_b80a_380403bed46f uuid := gen_random_uuid();
  v_order_db465ae5_b8f1_4245_9a02_34f41e61153a uuid := gen_random_uuid();
  v_order_dba22eed_2047_40d1_80d2_b0a59d6597b8 uuid := gen_random_uuid();
  v_order_dca13654_fd66_45be_bbef_6831d6f3839e uuid := gen_random_uuid();
  v_order_dd330e70_7144_44c8_b541_b670477163d0 uuid := gen_random_uuid();
  v_order_dd74128e_2bec_4ed6_b749_2807c97cfe2b uuid := gen_random_uuid();
  v_order_dfcc12ab_1920_41a9_89df_7cfa22d9af44 uuid := gen_random_uuid();
  v_order_e0e25228_4dde_4f65_90b1_6692cb82b8d6 uuid := gen_random_uuid();
  v_order_e16beef0_f1c0_4f05_b4bd_01dc8506f561 uuid := gen_random_uuid();
  v_order_e31fbc9b_3149_4782_acf8_9c291497b650 uuid := gen_random_uuid();
  v_order_e33ced74_93d4_4fa4_9a0c_0e95a0412669 uuid := gen_random_uuid();
  v_order_e4319103_6484_4571_a1ec_d714d2cfb084 uuid := gen_random_uuid();
  v_order_e480a1aa_6e63_4ec0_9810_3a7b42f40bd5 uuid := gen_random_uuid();
  v_order_e4deadf4_bd02_4a34_a41c_92039c0ba013 uuid := gen_random_uuid();
  v_order_e6cd6425_1b1e_48ad_9ce1_f011b42700b8 uuid := gen_random_uuid();
  v_order_e6e932ee_6cb1_4972_8e9b_8fda8ca1fe10 uuid := gen_random_uuid();
  v_order_e7163579_254a_478e_bd48_5670febe6108 uuid := gen_random_uuid();
  v_order_e7384974_4bbf_452f_b639_e440091a1d18 uuid := gen_random_uuid();
  v_order_e7a07563_ffb1_4f9e_8fe8_18b6ee4a5d2d uuid := gen_random_uuid();
  v_order_e99e4999_929b_48c2_820f_337864586030 uuid := gen_random_uuid();
  v_order_e9cca742_cd11_4f21_b8ef_275ead8cee6f uuid := gen_random_uuid();
  v_order_ea0ff900_5c06_4a3d_b41d_cd09463d8235 uuid := gen_random_uuid();
  v_order_ea388d6b_8cbe_4839_bcf6_e61a54b366e7 uuid := gen_random_uuid();
  v_order_ea3d6785_b3f6_4a28_84a6_f5c8c9cfafee uuid := gen_random_uuid();
  v_order_ea6fb5b6_aa7e_439e_a17d_ad7354398615 uuid := gen_random_uuid();
  v_order_ebf91396_e436_46e9_a28d_3b0a7eaa6811 uuid := gen_random_uuid();
  v_order_edf1a27c_72c2_4ad8_b066_7233353f567f uuid := gen_random_uuid();
  v_order_ee15ed87_711d_45bf_af52_76c54f841d9a uuid := gen_random_uuid();
  v_order_ef27d9a5_c1aa_477e_bcd2_4640e2dfe229 uuid := gen_random_uuid();
  v_order_f1af0790_134b_4fae_be53_44bc1776dad0 uuid := gen_random_uuid();
  v_order_f1d260d7_73dd_4332_baa6_7d2fcda635ea uuid := gen_random_uuid();
  v_order_f1edefcd_ebb4_4b49_a346_10b6814f0689 uuid := gen_random_uuid();
  v_order_f26883c1_d830_4871_ab5b_d1b5a8fff409 uuid := gen_random_uuid();
  v_order_f2691492_ea8c_4b55_8319_fe0aa82c09d5 uuid := gen_random_uuid();
  v_order_f2ada1ba_4fd8_4f3d_bb20_c1a513f54c56 uuid := gen_random_uuid();
  v_order_f30fe4da_ef57_45e4_8cfc_159cc13df92f uuid := gen_random_uuid();
  v_order_f48a91fd_23bd_4163_8062_710857a88633 uuid := gen_random_uuid();
  v_order_f764f45a_6193_4d16_ac5c_2d3a345c37e4 uuid := gen_random_uuid();
  v_order_f8f41fc4_5cd1_4cfb_b8b1_511377e97c26 uuid := gen_random_uuid();
  v_order_f907fe28_822b_4ae6_b536_ca40d46f5eb3 uuid := gen_random_uuid();
  v_order_fa02ecff_3be5_4f97_875b_3d4cb1c1b818 uuid := gen_random_uuid();
  v_order_fa3b636b_038a_42c8_90fe_8e229e8ec0ae uuid := gen_random_uuid();
  v_order_fa720a5c_efca_48f8_a1e8_ede9c79c52b0 uuid := gen_random_uuid();
  v_order_fb79ebce_ed8a_41a8_ada9_e12d3076f320 uuid := gen_random_uuid();
  v_order_fbfffea4_6630_4551_bde1_39d21774d2cb uuid := gen_random_uuid();
  v_order_fd1a5bd6_3589_4045_8cb6_a04d0fd404d0 uuid := gen_random_uuid();
  v_order_fd3b5d5a_3e28_43a3_bbc1_e801909abce6 uuid := gen_random_uuid();
  v_order_fd7a3c78_a3b1_473c_99d2_3e6a68cc7b41 uuid := gen_random_uuid();
  v_order_fd94950c_fd6b_4be5_a231_bc2371db2946 uuid := gen_random_uuid();
  v_order_fe1afdcf_0fbe_4ce3_9087_05ec214db195 uuid := gen_random_uuid();
  v_order_fe9812d5_312d_4adb_a15e_e538495e782f uuid := gen_random_uuid();
  v_order_fec347e8_9ce4_4bca_8e79_e7ee0fcbbb12 uuid := gen_random_uuid();
BEGIN

-- 1. Find the User in Auth
SELECT id INTO v_manager_id FROM auth.users WHERE email = 'prettystitches@gmail.com' LIMIT 1;
IF v_manager_id IS NULL THEN
  RAISE EXCEPTION 'User prettystitches@gmail.com not found in auth.users. Please sign up first!';
END IF;

-- 2. Create Organization
INSERT INTO public.organizations (id, name) VALUES (v_org_id, 'Pretty Stitches and Apparel');

-- 3. Create Shops
INSERT INTO public.shops (id, organization_id, name) VALUES (v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_org_id, 'Komarock');
INSERT INTO public.shops (id, organization_id, name) VALUES (v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_org_id, 'View Park Towers');

-- 4. Link User Profile (Owner)
INSERT INTO public.user_profiles (id, organization_id, shop_id, full_name, role, email, status) 
VALUES (v_manager_id, v_org_id, NULL, 'Hannah', 'owner', 'prettystitches@gmail.com', 'Active')
ON CONFLICT (id) DO UPDATE SET organization_id = EXCLUDED.organization_id, role = 'owner', status = 'Active';

-- 5. Import Workers
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number, created_at) 
VALUES (v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, 'Sonia', 'tailor', '+254 784 017 242', '2026-01-13 17:58:43.528+00');
INSERT INTO public.workers (id, organization_id, shop_id, name, role, phone_number, created_at) 
VALUES (v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, 'Florence', 'tailor', '0796 816 932', '2026-01-05 15:39:12.951+00');

-- 6. Import Clients (with created_at properly!)
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_084f0802_a8cb_4421_b455_c803ef312370, v_org_id, 'Joy Kinaga(Custom White Dress)', '0729 282 296', '[{"date": "2026-02-23T16:16:45.773+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":40,\"Length\":35,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-23 16:16:45.773+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_088a9537_5d7d_491e_8ae7_6e179881ce65, v_org_id, 'Brian Bett(Kini Set, Navy Pinstripe)', '‪+254 728 085834‬', '[{"date": "2026-02-12T11:34:05.111+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":0},\"Shirt\":{},\"Trouser\":{}}"}]'::jsonb, 'Suit', '', '2026-02-12 11:34:05.111+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_0a247e7a_0093_49ce_8a60_998b7a00344d, v_org_id, 'Lynnet Ongeri(Navy Mara,Tweed,Navy Cooperate,Red Mini Party)', '0702970585', '[{"date": "2026-01-31T14:43:54.697+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":30,\"Hips\":41,\"Length\":39,\"Sleeve\":23}}"}]'::jsonb, 'Dress', '', '2026-01-31 14:43:54.697+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_14645141_a52a_4bb5_8cbd_cf1e21c3485f, v_org_id, 'Judy Kioko(Red Rafiki)', '0746076117', '[{"date": "2026-02-14T11:35:27.103+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":37,\"Waist\":30,\"Hips\":39,\"Length\":33,\"Sleeve\":25}}"}]'::jsonb, 'Dress', '', '2026-02-14 11:35:27.103+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_1492ab21_4ca5_4fa7_b57a_0ece25ed92ce, v_org_id, 'Redimeter Mwangu(White Blended Corset Dress)', '0791951403', '[{"date": "2026-02-25T07:48:18.821+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":26,\"Hips\":40,\"Length\":33}}"}]'::jsonb, 'Dress', '', '2026-02-25 07:48:18.821+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_15d0a629_ab70_440c_8b94_ca1333ca599a, v_org_id, 'Cheryl Musumba (Red Rafiki)', '‪+254 711 917678‬', '[{"date": "2026-02-11T08:30:52.298+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":28,\"Hips\":38,\"Length\":35,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-11 08:30:52.298+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_17d3495f_ba73_4c2e_88f2_9e9b7fc90366, v_org_id, 'Angela Wambua(lilac sonja dress)', '0790943759', '[{"date": "2026-02-18T12:06:42.193+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":30,\"Hips\":40,\"Length\":37,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-18 12:06:42.193+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_1c11efb0_8b04_4ba2_a7f2_dfb22b66027f, v_org_id, 'Cynthia Cherotich(Red Longsleeved Backless)', '‪+254 714 208055‬', '[{"date": "2026-02-09T12:49:49.073+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":17,\"Bust\":40,\"Waist\":33,\"Hips\":44,\"Length\":35,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-09 12:49:49.073+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_2637da6d_4eb9_4d0a_a4be_faa448f53ab6, v_org_id, 'Sherlene Macharia(emerald green rose maxi)', '0769001555', '[{"date": "2026-02-23T11:48:47.342+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":31.5,\"Waist\":26,\"Hips\":37.5,\"Length\":52,\"Sleeve\":19}}"}]'::jsonb, 'Dress', '', '2026-02-23 11:48:47.342+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_270e6252_090e_435c_88db_e6ffa846b445, v_org_id, 'Hellen Mbalanya(White Mona Set)', '0721356257', '[{"date": "2026-01-30T14:27:50.425+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":43,\"Length\":57,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-01-30 14:27:50.425+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_273469c6_a168_48b9_a826_47124cd560ea, v_org_id, 'Peninah Mbiu(B.Pink Mona Set)', '0796906267', '[{"date": "2026-02-05T09:33:09.686+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":41,\"Length\":56}}"}]'::jsonb, 'Dress', '', '2026-02-05 09:33:09.686+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_279ac725_453f_4cef_95b1_a7a9f35dfd67, v_org_id, 'Shelmith Wambugu(Red Velvet corset Dress)', '0703914717', '[{"date": "2026-02-11T07:43:23.377+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":28,\"Hips\":41,\"Length\":35}}"}]'::jsonb, 'Dress', '', '2026-02-11 07:43:23.377+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_2b548ae7_ec0f_4a78_82e2_f9a7f786e7cf, v_org_id, 'Susan Wambui(Red Sonja Dress)', '0743078617', '[{"date": "2026-02-09T10:42:37.547+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":29,\"Hips\":42,\"Length\":37,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-09 10:42:37.547+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_40b74c40_0aa9_47ca_829b_2f94ebda995b, v_org_id, 'Ann Nasimiyu(Blush Pink Mona Dress)', '0791273834', '[{"date": "2026-02-20T08:57:33.846+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":27,\"Hips\":39,\"Length\":55}}"}]'::jsonb, 'Dress', '', '2026-02-20 08:57:33.846+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_417f7936_7c59_47bf_9594_5749faa2bb1e, v_org_id, 'Millicent Meja(Red Mini Party)', '0795018358', '[{"date": "2026-01-10T14:28:47.848+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":31,\"Hips\":44,\"Length\":55,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-01-10 14:28:47.848+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_45d3bf4f_75de_448b_a98d_55e7691f3bcd, v_org_id, 'Eunice Mukuba(Red Chic Charm)', '0769183282', '[{"date": "2026-02-02T03:43:04.949+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":14,\"Bust\":33,\"Waist\":27,\"Hips\":36,\"Length\":36,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-02 03:43:04.949+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_4686f18e_dd18_4180_bf04_d77bd1352d8b, v_org_id, 'Monica Mburu(Lilac Chic Charm)', '0713758963', '[{"date": "2026-02-18T16:47:02.837+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0}}"}]'::jsonb, 'Dress', '', '2026-02-18 16:47:02.837+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_46ada19d_80f1_4597_9080_7365cb5290e7, v_org_id, 'Mercy Sitienei', '0726366689', '[{"date": "2026-01-05T15:41:19.065+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":29,\"Hips\":39,\"Length\":38,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-01-05 15:41:19.065+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_481818bb_4a48_4185_89d6_0cd98eb530c1, v_org_id, 'Joan Kinaro( Red Mini Party)', '0748484469', '[{"date": "2026-02-09T08:16:48.672+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-09 08:16:48.672+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_4838e701_e667_4c0a_b076_d2b054501163, v_org_id, 'Anne Njoroge(Boss Babe)', '+254 737 415722', '[{"date": "2026-02-11T15:25:25.892+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":29,\"Hips\":43,\"Length\":40,\"Sleeve\":25}}"}]'::jsonb, 'Dress', '', '2026-02-11 15:25:25.892+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_49e0ed04_d218_4ac1_ac7d_c9e152e19a07, v_org_id, 'Ivyne Kibet(Red Rafiki)', '0793326638', '[{"date": "2026-02-13T11:41:05.271+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":34,\"Hips\":42,\"Length\":38,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-13 11:41:05.271+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_4c16383e_819c_4465_bbe8_af643461c0fb, v_org_id, 'Faith Kamau(Maroon Lily Dress & Hot Pink Boss Babe)', '0721642519', '[{"date": "2026-02-18T15:53:57.893+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":39,\"Waist\":34,\"Hips\":43,\"Length\":39,\"Sleeve\":24}}"}]'::jsonb, 'Dress', '', '2026-02-18 15:53:57.893+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_4dbf16b8_2127_467a_b39e_7288da398c2e, v_org_id, 'Cadlar Juma ( white backless longsleeve)', '0725094902', '[{"date": "2026-02-02T14:14:06.028+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":26,\"Hips\":38,\"Length\":36,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-02 14:14:06.028+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_5172e0af_cf25_4c72_81bc_190e2f4f20a1, v_org_id, 'Nazeline Wanyika(Red Sonja)', '0702083828', '[{"date": "2026-02-23T10:28:56.687+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":26,\"Hips\":40,\"Length\":35,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-23 10:28:56.687+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_548cc78e_5fca_4f98_95f0_687faa2b8e39, v_org_id, 'Jacquline Muriithi(Navy Cooperate)', '0769947872', '[{"date": "2026-02-11T07:10:35.536+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0}}"}]'::jsonb, 'Dress', '', '2026-02-11 07:10:35.536+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_57e8bf91_bac7_4e9d_92ca_cb7f5e878b86, v_org_id, 'Abigael(Red Sonja Dress)', '0715342363', '[{"date": "2026-02-21T07:49:20.208+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":18,\"Bust\":45,\"Waist\":35,\"Hips\":50,\"Length\":38,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-21 07:49:20.208+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_5b2cd878_4c19_4485_aa5b_92d9331c4939, v_org_id, 'Dickson Gichuki(red rafiki)', ' +254 701 772828 ', '[{"date": "2026-02-19T12:08:41.784+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-19 12:08:41.784+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_5c717ae6_8aa7_461d_8cd9_3a6cd842ecd5, v_org_id, 'Sharon Soila(navy blue mara and mini party dress)', '0718414903', '[{"date": "2026-01-26T09:43:46.858+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":14,\"Bust\":34.5,\"Waist\":29,\"Hips\":39,\"Length\":39,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-01-26 09:43:46.858+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_5e4c8e8c_ebf1_411e_964b_1f6a2e0b75c6, v_org_id, 'Abby Jane( Brown Sonja)', '0757642325', '[{"date": "2026-02-04T14:19:45.239+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":28,\"Hips\":39,\"Length\":35,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-04 14:19:45.239+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_625c9fb1_40d5_4b83_adff_85aef2bed245, v_org_id, 'Christine Zachary(Black Mini Party)', '0713864087', '[{"date": "2026-01-13T18:03:04.697+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":26,\"Hips\":40,\"Length\":36,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-01-13 18:03:04.697+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_6596e55e_692a_4940_826d_d1656ec9572d, v_org_id, 'Fridah Gatwiri(Brown Kini Pant Set)', '0795533627', '[{"date": "2026-02-24T12:23:47.929+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":16,\"Chest\":35,\"Bodice\":17,\"Waist\":28},\"Shirt\":{},\"Trouser\":{\"Waist\":27,\"Hips\":41,\"Thigh\":26,\"Crotch\":29}}"}]'::jsonb, 'Suit', '', '2026-02-24 12:23:47.929+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_659b39cc_9184_42e9_af83_8e3c7fcfddc7, v_org_id, 'Anne Gichini(Lilac Rafiki)', '‪+254 720 405290‬', '[{"date": "2026-02-07T14:34:17.419+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-07 14:34:17.419+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_68a9a0ca_b2f4_4262_ba04_0d858262548f, v_org_id, 'Loraine Akinyi(White Sonja)', '‪+254114535734‬', '[{"date": "2026-02-23T13:09:31.074+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":42,\"Waist\":37,\"Hips\":43,\"Length\":40,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-23 13:09:31.074+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_699e1ba6_612d_4709_a1b9_8f851e673c78, v_org_id, 'Hilda Wanjiku( Kini Set & Rich Aunty)', '0711162628', '[{"date": "2026-01-17T10:16:03.047+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":44,\"Length\":56,\"Sleeve\":12}}"}]'::jsonb, 'Dress', '', '2026-01-17 10:16:03.047+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_6e4ce4bd_3b89_45ad_8f50_aa1ae8731432, v_org_id, 'Priscilla Mwaniki', '0729886822', '[{"date": "2026-01-19T07:11:02.538+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":31,\"Waist\":24,\"Hips\":36,\"Length\":55,\"Sleeve\":10}}"}]'::jsonb, 'Dress', '', '2026-01-19 07:11:02.538+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_6effee79_b9b2_4c77_b487_80874d23046a, v_org_id, 'Shelmith(White Chic Charm & Black A shape)', '‪+254 748 835524‬', '[{"date": "2026-02-09T07:01:26.498+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":29,\"Hips\":45,\"Length\":34,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-09 07:01:26.498+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_714ffed1_5bf0_4835_92d4_5e4da2c5ffe3, v_org_id, 'Immaculate Babalanda(Maroon Sonja Dress)', '‪+256 754 334010‬', '[{"date": "2026-02-09T18:27:50.55+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":43,\"Length\":39,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-09 18:27:50.55+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_7170249d_356f_4587_a409_b0b6a35ea7c2, v_org_id, 'Immaculate Kinyua(Red Sonja)', '0745564724', '[{"date": "2026-02-09T06:46:52.418+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":33.5,\"Waist\":27,\"Hips\":41,\"Length\":34,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-09 06:46:52.418+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_769449eb_1619_4673_9287_07352c4e9cb7, v_org_id, 'Naomi Mwangi(Navy Cooperate)', '0758800595', '[{"date": "2026-02-05T08:55:16.377+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":34,\"Hips\":49,\"Length\":40,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-05 08:55:16.377+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_78228d75_9259_4858_a480_b36330f144fc, v_org_id, 'Jackline Kobia(Maroon Lily Dress)', '0718640804', '[{"date": "2026-02-20T07:11:29.918+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":27,\"Hips\":36,\"Length\":35}}"}]'::jsonb, 'Dress', '', '2026-02-20 07:11:29.918+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_800c52ed_502c_4a19_acd3_9794cc43c939, v_org_id, 'Collins Keya(red rafiki)', '0796499276', '[{"date": "2026-02-17T12:13:17.895+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":37,\"Length\":35,\"Sleeve\":24}}"}]'::jsonb, 'Dress', '', '2026-02-17 12:13:17.895+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_810c8a69_7b3e_4a62_97ea_ad3dd077cd6b, v_org_id, 'Yvonne Kwamboka(Black kini pants set)', '0746550886', '[{"date": "2026-02-19T12:42:28.03+00:00", "garment": "Coat", "measurements": "{\"Coat\":{\"Shoulder\":16,\"Chest\":33.5,\"Waist\":26,\"Sleeve\":10,\"Length\":17,\"Hips\":40}}"}]'::jsonb, 'Coat', '', '2026-02-19 12:42:28.03+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_82bb6b03_c548_43fc_a266_cab7e6a54b80, v_org_id, 'Megan Kweyu(Red Mini Party', '0748120316', '[{"date": "2026-02-18T10:10:55.049+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-18 10:10:55.049+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_85f19841_2cab_4dad_aaf9_30c6c03e0875, v_org_id, 'Samara Njeru(Burgundy Custom Order)', '0721109246', '[{"date": "2026-01-21T10:12:15.526+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":27,\"Hips\":38,\"Length\":32,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-01-21 10:12:15.526+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_880ffcea_f7a4_48e0_a441_b17ef212c105, v_org_id, 'Riziki(Custom corset & skirt)', '+254 718 148 505', '[{"date": "2026-01-28T15:43:05.087+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":38,\"Waist\":32,\"Hips\":41.5,\"Length\":44,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-01-28 15:43:05.087+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_8c63110a_5407_47c8_8a70_41e005e458fc, v_org_id, 'Juliet Nyambura(navy blue mini party)', '0798207431 ', '[{"date": "2026-02-17T13:26:18+00:00", "garment": "Dress", "measurements": "{\"Dress\":{}}"}]'::jsonb, 'Dress', '', '2026-02-17 13:26:18+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_8d36befc_e69d_430c_bb51_f83316896c74, v_org_id, 'Faith Kasyoka(Navy blue chinese collar)', '0741096604', '[{"date": "2026-02-10T10:40:42.621+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":39.5,\"Waist\":31,\"Hips\":43,\"Length\":40,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-10 10:40:42.621+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_97424971_57f1_46c1_aacc_9583645fc1a1, v_org_id, 'Nelly Mukami(Lilac Rafiki)', '0742897594', '[{"date": "2026-02-19T17:14:00.669+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-19 17:14:00.669+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_9caa9548_bbd0_4ec5_af2e_90cc7b486e56, v_org_id, 'Nelly Njire( Mini Party & Mara)', '‪0797218970‬', '[{"date": "2026-01-29T09:34:06.992+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":36,\"Waist\":28,\"Hips\":40,\"Length\":36,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-01-29 09:34:06.992+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_9ebc8f96_07ce_4e34_b42d_1a714d2366c5, v_org_id, 'Purity Muthoni(Navy Cooperate)', '0717159064', '[{"date": "2026-02-19T15:00:31.325+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-19 15:00:31.325+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_a3fed2be_5eac_4380_bb89_31320ac954c6, v_org_id, 'Eunice Njoroge(Red will dress &chocolate brown rafiki)', '0724927669', '[{"date": "2026-02-02T14:11:10.148+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":34,\"Hips\":44,\"Length\":34,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-02 14:11:10.148+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_aade0e7d_3516_4ccf_988b_aa14ea7ac46b, v_org_id, 'Ruth Jelagat(Mini Party, Chic Charm & Mara)', '0792663291', '[{"date": "2026-01-17T11:51:22.101+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":27,\"Hips\":36,\"Length\":34,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-01-17 11:51:22.101+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_ac1c636a_ef54_4446_8b4b_8d5ca3e03920, v_org_id, 'Faith Mwikali(Red Sonja Dress)', '0705210437', '[{"date": "2026-02-20T15:49:38.81+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":33,\"Hips\":44,\"Length\":39,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-20 15:49:38.81+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_afa88355_c935_4923_abf3_2c14324242ef, v_org_id, 'Baby(Burgundy Custom)', '+254 790 680453', '[{"date": "2026-02-09T07:54:17.799+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":26,\"Hips\":38,\"Length\":32,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-09 07:54:17.799+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_afaa2f34_d1d0_499f_a64c_94453f5ab3f4, v_org_id, 'Emelda Marcos(maroon cooperate+ navy cooperate)', '0707064753', '[{"date": "2026-01-10T15:00:21.421+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":38,\"Waist\":32,\"Hips\":44,\"Length\":38,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-01-10 15:00:21.421+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_b5af2bd0_fad7_4a85_9e50_9ec3a0f71f82, v_org_id, 'Emmaculate Muriithi', '0715479387', '[{"date": "2026-02-10T11:48:23.383+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-10 11:48:23.383+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_b60c0e39_9144_4fc7_a2e8_0e7671e8a345, v_org_id, 'Hannah Thaara(custom 2 piece)', '0722940076', '[{"date": "2026-01-27T13:18:41.567+00:00", "garment": "Suit", "measurements": "{\"Coat\":{\"Shoulder\":16,\"Chest\":46,\"Bodice\":16,\"Waist\":42,\"Bicep\":19,\"Sleeve\":8,\"Length\":31,\"Hips\":56},\"Shirt\":{},\"Trouser\":{\"Waist\":44,\"Hips\":56,\"Thigh\":36,\"Length\":43}}"}]'::jsonb, 'Suit', '', '2026-01-27 13:18:41.567+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_bbee2bb5_9bf5_4a08_bd62_6726ad307d67, v_org_id, 'Ruth Kamau(Maroon Lily Dress)', '0793018852', '[{"date": "2026-02-17T09:11:57.755+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":42,\"Length\":37}}"}]'::jsonb, 'Dress', '', '2026-02-17 09:11:57.755+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_bcbb4d5a_c947_4e36_8137_bf876d94bdb2, v_org_id, 'Scola Joseph(Red Mini Party)', '0757542373', '[{"date": "2026-02-10T12:14:45.142+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":24,\"Hips\":36,\"Length\":37,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-10 12:14:45.142+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_bd1b3076_ca92_454c_b4b6_220f7caa6267, v_org_id, 'Mary Ngele( Turquiose Will Dress)', '0796245540', '[{"date": "2026-02-02T06:32:32.771+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":31,\"Waist\":27,\"Hips\":36,\"Length\":36,\"Sleeve\":25}}"}]'::jsonb, 'Dress', '', '2026-02-02 06:32:32.771+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_bebeb9fe_47e3_487f_8596_135f47adf77a, v_org_id, 'Stephanie Achieng(Rafiki & Mini Party)', '0707896952', '[{"date": "2026-01-08T16:07:07.822+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":31,\"Hips\":43,\"Length\":39,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-01-08 16:07:07.822+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_bf03d84f_a5f1_4f72_a219_493e7288da69, v_org_id, 'Mercy Rotich(Burgundy Custom Order)', '‪+61 416 845 731‬', '[{"date": "2026-02-24T18:51:08.083+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":32,\"Hips\":43,\"Length\":56,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-24 18:51:08.083+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_c500c02a_0155_4db9_b627_8f0bbcca4e4b, v_org_id, 'Kendi Loreen(White Cooperate)', '0712690988', '[{"date": "2026-02-18T10:08:02.097+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":43,\"Length\":35,\"Sleeve\":26}}"}]'::jsonb, 'Dress', '', '2026-02-18 10:08:02.097+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_cfb18d8e_f0c0_49b9_be35_c5ca40bb501b, v_org_id, 'Georgette Thuku', '0726244037', '[{"date": "2026-02-09T15:00:19.503+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":40,\"Length\":57,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-09 15:00:19.503+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_d01c519b_26b7_4e09_b32c_85a32b79c8ea, v_org_id, 'Lydia Moraa( Hot pink Boss Babe)', '0799123484', '[{"date": "2026-01-24T14:51:15.557+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":30,\"Hips\":40,\"Length\":38,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-01-24 14:51:15.557+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_e328dfc1_765b_4042_b5c4_4549abe9d572, v_org_id, 'Marionnet Kerubo', '0724997298', '[{"date": "2026-02-04T12:11:46.35+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":41,\"Length\":35,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-04 12:11:46.35+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_e62afcd1_d6e5_4e4f_b34c_1882870a3317, v_org_id, 'Shirleen Nyambura(Ocean Blue & Navy blue Blazer dress)', '0711289292', '[{"date": "2026-02-17T11:06:59.501+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":17,\"Bust\":38,\"Waist\":34,\"Hips\":48,\"Length\":43,\"Sleeve\":24}}"}]'::jsonb, 'Dress', '', '2026-02-17 11:06:59.501+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_ea0d5eeb_9c45_41ff_875e_6fa2ff2a7e56, v_org_id, 'Stacy Achola', '0726306688', '[{"date": "2026-01-07T07:20:25.407+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16.5,\"Bust\":35,\"Waist\":28,\"Hips\":42,\"Length\":38,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-01-07 07:20:25.407+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_ef25dffb_9d23_46e6_9634_8775d1cc96e7, v_org_id, 'Ruth (Black Custom Order)', '0705296530', '[{"date": "2026-01-30T09:55:44.413+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":15,\"Bust\":38,\"Waist\":30,\"Hips\":42,\"Length\":57,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-01-30 09:55:44.413+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_f456b44f_65b0_40a5_8fd6_1b8bdf881f89, v_org_id, 'Antonellah Lokitela (kini pant set)', '0758072074', '[{"date": "2026-01-30T12:17:32.706+00:00", "garment": "Suit", "measurements": "{\"Top\":{\"Shoulder\":16,\"Chest\":35,\"Waist\":30,\"Hips\":41.5},\"Trouser\":{\"Waist\":30,\"Hips\":41.5,\"Thigh\":26,\"Length\":45,\"Crotch\":29}}"}]'::jsonb, 'Suit', '', '2026-01-30 12:17:32.706+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_f7707435_b987_4373_8229_f2a784f16bb7, v_org_id, 'Lilian Wanjiru(Red Sonja,Navy Cooperate, Maroon Cooperate)', '0799776069', '[{"date": "2026-02-03T10:16:07.226+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":42,\"Length\":37,\"Sleeve\":27}}"}]'::jsonb, 'Dress', '', '2026-02-03 10:16:07.226+00');
INSERT INTO public.clients (id, organization_id, name, phone, measurements_history, last_garment_type, notes, created_at) 
VALUES (v_client_fbdda284_3718_46ac_a845_a4fca1e3e3e8, v_org_id, 'Juliet Nyambura(Navy Mini Party)', '0798207431', '[{"date": "2026-02-17T13:28:51.344+00:00", "garment": "Dress", "measurements": "{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"}]'::jsonb, 'Dress', '', '2026-02-17 13:28:51.344+00');

-- 7. Import Orders
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0076ad32_0554_44c2_a97e_d14d4bd1fa58, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Janet Njiru(Blush Pink Sonja)', '‪+254 714 916160‬', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-03-12 08:15:57.737+00', '2026-03-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_00c6872a_7934_41ae_8ced_2e44bdf151db, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Shelmith Wambugu(Red Velvet corset Dress)', '0703914717', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":28,\"Hips\":41,\"Length\":35}}"'::jsonb, 6500, 6500, 7, '2026-02-11 07:43:23.377+00', '2026-02-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_02801f54_cdac_4bec_b732_13a41ae6ccca, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Hannah Thaara(custom 2 piece)', '0722940076', 'Suit', '"{\"Coat\":{\"Shoulder\":16,\"Chest\":46,\"Bodice\":16,\"Waist\":42,\"Bicep\":19,\"Sleeve\":8,\"Length\":31,\"Hips\":56},\"Shirt\":{},\"Trouser\":{\"Waist\":44,\"Hips\":56,\"Thigh\":36,\"Length\":43}}"'::jsonb, 5000, 5000, 7, '2026-01-27 13:18:41.567+00', '2026-02-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0298153c_9662_4865_97f3_7baeec6f1a70, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Zipporah(brown pinstripe kini pants set)', '0711200484', '', '"{}"'::jsonb, 4700, 4700, 7, '2026-06-23 10:38:33.291+00', '2026-07-01', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_035a0b87_5e0a_4747_ab10_096701774729, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Immaculate Kinyua(Red Sonja)', '0745564724', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33.5,\"Waist\":27,\"Hips\":41,\"Length\":34,\"Sleeve\":27}}"'::jsonb, 3700, 3700, 7, '2026-02-09 06:46:52.418+00', '2026-02-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_04ac11e0_f980_430f_b891_ef0c764c4c6e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Agnes Muthini(Red Rafiki)', '0704034993', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":40,\"Length\":34}}"'::jsonb, 3700, 3700, 7, '2026-04-07 07:24:14.466+00', '2026-04-09', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_054e15de_3733_4e03_99b2_a994b362f130, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Juliana Kasungwa(chocolate brown Sonja )', '0703301354', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":26,\"Hips\":40,\"Length\":38}}"'::jsonb, 3700, 3700, 7, '2026-05-29 15:44:58.866+00', '2026-06-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_05cd7b36_cbee_4fa3_aed9_bfbc42d61c6e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Catherine Wambua(Burgundy Sonja Dress)', '‪+254 715 599088‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":30,\"Hips\":48,\"Length\":38}}"'::jsonb, 3700, 2000, 1, '2026-06-30 15:17:55.372+00', '2026-07-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_05f7acc6_8526_422c_88d8_bb7d94da23c6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Valentine Ndukai(Beige Rafiki)', '‪+254 798 116189‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":29,\"Hips\":38,\"Length\":40,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-03-24 18:29:50.256+00', '2026-03-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0607675f_fb89_4c83_b7c7_919d9e426eee, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ann Wangari(Maroon Lily Dress)', '0740766512', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":46,\"Length\":36}}"'::jsonb, 3700, 3700, 7, '2026-05-09 14:45:30.427+00', '2026-05-14', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0626eac1_6293_4418_bafc_41a8daeffa3c, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Angel Muthoni(White Chic charm)', '0708529494', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4200, 4200, 7, '2026-06-17 11:00:40.425+00', '2026-06-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0721cbd0_fb36_4b2e_9c25_3931c8e11c9b, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Juliet Wanjiku(Red Rafiki)', '0700399673', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-05-16 11:33:42.516+00', '2026-05-16', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_079030b9_cd99_434b_8980_c536f1fbff82, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Bridgit Agaba (5 black sonja dresses)', '‪+256 787 967568‬', 'Dress', '"{\"Dress\":{}}"'::jsonb, 17500, 17500, 7, '2026-06-02 14:51:00.526+00', '2026-06-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_07f19229_c185_4a64_a8f1_6fdd69245e36, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Damaris Wangeci(Tweed Dress)', '0701266072', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":30,\"Hips\":41,\"Length\":40}}"'::jsonb, 4500, 4500, 7, '2026-03-21 09:56:00.269+00', '2026-03-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_08091250_d494_443e_b419_a28e349bdef4, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Georgina Jepleting(Navy Cooperate)', '‪+254 711 318854‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":30,\"Hips\":40,\"Length\":34}}"'::jsonb, 4200, 4200, 7, '2026-05-27 10:36:21.294+00', '2026-06-03', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0ababa08_aa34_4744_b19a_853ffaa48a3a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Haliet Munene(Red Rosè)', '‪+254 708 538990‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":41,\"Waist\":35,\"Hips\":45,\"Length\":42}}"'::jsonb, 4000, 4000, 7, '2026-06-17 13:00:52.647+00', '2026-06-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0abaebaf_0c19_4a3b_876e_3c7787bf39c0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Nelly Nkipidah(Chocolate Brown Maxi)', '0712686542', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":37,\"Hips\":46,\"Length\":57}}"'::jsonb, 4500, 4500, 7, '2026-03-11 07:37:15.52+00', '2026-03-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0b627b54_94b8_4a99_ade6_339762265279, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Purity Kuria(Lilac Boss Babe)', '0759114063', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":30,\"Hips\":41,\"Length\":36}}"'::jsonb, 3700, 3700, 7, '2026-02-26 15:02:56.189+00', '2026-03-03', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0b790c27_d52f_49d5_bac1_b388e6d1eeeb, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Winnie(Ankara Skirt & black top)', '0726568172', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":41,\"Waist\":37,\"Hips\":0,\"Length\":21}}"'::jsonb, 5200, 5200, 7, '2026-03-06 14:26:00.971+00', '2026-03-13', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0c8af382_4867_46ea_a8fb_c83038b4d021, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Daisy Njue(Navy Cooperate)', '0701298377', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":29,\"Hips\":39,\"Length\":37}}"'::jsonb, 4200, 4200, 7, '2026-03-18 16:17:20.274+00', '2026-03-20', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0d0aa9c4_adc2_4aae_92a0_b3b044e9e02e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Catherine Ndemo(Lilac Rafiki Dress)', '0796968194', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-06-30 14:34:26.564+00', '2026-06-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0d103666_3eaa_43c1_9dac_2c7a3e038426, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Loraine Akinyi(White Sonja)', '‪+254114535734‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":42,\"Waist\":37,\"Hips\":43,\"Length\":40,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-02-23 13:09:31.074+00', '2026-02-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0e3b02c2_94fa_47fd_aa09_2d2f3d52336e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Naomi Kwamboka(Burgundy Mini Party)', '0705080292', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":27,\"Hips\":39,\"Length\":37}}"'::jsonb, 3500, 3500, 7, '2026-04-11 12:15:16.047+00', '2026-04-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0e9eb187_a964_4ff0_b11b_763b66f5310a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Beth Mwangi(Red Rafiki)', '0713418261', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-04-18 14:21:11.468+00', '2026-04-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_0f09c1a7_4295_4a4b_94bc_70fbdb5b0807, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Purity Mwangi(J.Green Kini Pant set)', '0727157361', 'Pant set', '"{\"Shirt\":{},\"Trouser\":{}}"'::jsonb, 4500, 4500, 7, '2026-05-26 12:50:58.066+00', '2026-05-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_105b4470_aad5_4220_a3bb_2913fcff7fb5, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Josephine Hakonga(Burgundy Sonja Dress)', '‪+254 741 352723‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":32,\"Waist\":25,\"Hips\":35,\"Length\":37,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-06-19 12:36:54.31+00', '2026-06-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_10985031_5124_4519_b293_5e38a42f79f3, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Anita Maiyo( Red Rafiki & Orange Mini party)', '0724452855', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":29,\"Hips\":42,\"Length\":38}}"'::jsonb, 7200, 7200, 7, '2026-04-10 16:14:17.976+00', '2026-04-15', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_1194f579_8390_42a9_baf1_a9556923eb70, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Wanjiru Irungu(Peach Mini Party)', '‪+254105953869‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":31,\"Hips\":40,\"Length\":36}}"'::jsonb, 4200, 4200, 7, '2026-05-21 16:16:26.584+00', '2026-05-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_1198ce1c_36b8_4230_9a2b_633ff3a34485, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Caroline Nderi(Maxi Blackcurrant ,Orange Chic Charm)', '0795356072', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":38,\"Waist\":32,\"Hips\":42,\"Length\":37}}"'::jsonb, 8000, 8000, 7, '2026-03-21 13:27:49.834+00', '2026-03-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_12819aa5_d08a_42ac_bf04_89bb07d2b9ed, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Okoth(C.Brown Bow Dress)', '0740747166', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-03-13 14:40:05.032+00', '2026-03-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_13095957_37e4_4868_b240_4041465dbe55, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Pep Kamau(Blush Pink Mona Set)', '0759643471', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":27,\"Hips\":37,\"Length\":52}}"'::jsonb, 3950, 3950, 7, '2026-06-06 14:08:44.852+00', '2026-06-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_13243e03_5e09_4024_a21f_e8ed1233323b, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Cynthia Katusya(Red Rafiki, Black Chic Charm)', '0743743171', 'Dress', '"{\"Dress\":{}}"'::jsonb, 7200, 7200, 7, '2026-03-26 15:02:22.989+00', '2026-03-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_1390ef8a_e13b_40bb_89a7_c536cbbf323c, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ann Nasimiyu(Blush Pink Mona Dress)', '0791273834', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":27,\"Hips\":39,\"Length\":55}}"'::jsonb, 3950, 3950, 7, '2026-02-20 08:57:33.846+00', '2026-02-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_13f238bf_d58d_4fed_981d_2aef763d292b, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lydia Robyn(Lilac Sonja Dress)', '‪+254 706 160040‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":36,\"Waist\":27,\"Hips\":39,\"Length\":37,\"Sleeve\":25}}"'::jsonb, 3700, 3700, 7, '2026-06-13 14:38:59.64+00', '2026-06-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_17e43ff7_f45d_4b4a_83d5_66f5558b176a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ruth Jepchirchir(Burgundy Blazer Dress)', '‪+254 797 679330‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":35,\"Hips\":40,\"Length\":35,\"Sleeve\":25}}"'::jsonb, 7500, 7500, 7, '2026-06-22 10:10:06.252+00', '2026-06-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_17f1a5f1_0f0b_4629_82a7_4926ce3440af, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Doreen Jelimo(Custom corset)', '‪+61 428 361 093‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":40,\"Length\":32}}"'::jsonb, 14500, 14500, 7, '2026-03-12 13:17:12.795+00', '2026-03-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_18b284f3_3738_4f9c_b05c_02a863e1a06a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Winnie Ndonga(Burgundy Sonja & Rafiki)', '0790725166', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":50,\"Length\":34}}"'::jsonb, 7400, 3700, 1, '2026-06-27 10:15:49.338+00', '2026-06-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_19781198_57d6_42d0_ac22_3c7ab36b0172, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Jennifer Rutto(Red Mini Party)', '‪+254 721 311600‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":46,\"Waist\":41,\"Hips\":53,\"Length\":37}}"'::jsonb, 3500, 3500, 7, '2026-06-16 12:22:11.125+00', '2026-06-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_1a363481_e9c7_45d2_b673_e806842a6d25, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Maureen Kwamboka(Red Maxi Backless)', '0702200194', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":30,\"Waist\":24,\"Hips\":38,\"Length\":53}}"'::jsonb, 3500, 3500, 7, '2026-06-12 14:08:41.451+00', '2026-06-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_1f113fa4_caad_4027_b97e_e0538dd372e9, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Cheruto', '+61 420 818 894', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":30,\"Hips\":40,\"Length\":35}}"'::jsonb, 6500, 6500, 7, '2026-02-28 10:29:29.242+00', '2026-03-03', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_211ddf87_cbc7_4b08_a9f8_5c016a1ac3df, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lilian Owino(Mustard Maxi Dress)', '0717 610 307', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4500, 4500, 7, '2026-04-06 09:51:10.238+00', '2026-04-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_22186ffa_a0c1_42f7_8551_031ef5e36a51, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Diana Chemutai(Navy Kini Pant Set)', '0113662475 Diana', 'Pant set', '"{\"Shirt\":{\"Shoulder\":15,\"Chest\":33,\"Bust\":33,\"Bodice\":16,\"Waist\":26,\"Long Sleeve\":23},\"Trouser\":{\"Waist\":26,\"Hips\":33,\"Thigh\":24,\"Length\":37}}"'::jsonb, 4800, 4800, 7, '2026-06-03 14:04:33.284+00', '2026-06-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_229ce27a_279c_45e7_acce_e657728c7771, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lilian Owino(Hot Pink Backless)', '0717610307', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":35,\"Hips\":44,\"Length\":37}}"'::jsonb, 3700, 3700, 7, '2026-03-31 09:42:27.262+00', '2026-03-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_23a7aa01_71bf_4ac6_8ad0_885138422b5b, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Rotich(Custom Black Dress)', '‪+61 416 845 731‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":40,\"Waist\":32,\"Hips\":43,\"Length\":35}}"'::jsonb, 9500, 9500, 7, '2026-03-06 08:50:15.905+00', '2026-03-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_23c08a40_0585_4137_9418_64379817de46, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Claire Koech(white a shape)', '‪+254 794 037648‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":28,\"Hips\":38,\"Length\":34}}"'::jsonb, 4500, 4500, 7, '2026-05-12 11:20:25.918+00', '2026-05-16', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_2567af9f_3253_4ab1_80c7_cffe58c6653f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Kendi Loreen(White Cooperate)', '0712690988', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":43,\"Length\":35,\"Sleeve\":26}}"'::jsonb, 4200, 4200, 7, '2026-02-18 10:08:02.097+00', '2026-02-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_25c9d6c3_f731_4764_8970_126f278cf204, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercyline Nafuna(Red Rafiki)', '0719532822', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-04-28 14:11:17.685+00', '2026-04-28', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_26560755_83c8_4d76_a7e1_c07f7f97e3b9, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Reena Chepkoech(Burgundy longlsleeved Backless)', '011 1395136', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":32,\"Hips\":40,\"Length\":37}}"'::jsonb, 3700, 3700, 7, '2026-05-15 14:52:21.881+00', '2026-05-20', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_286f7ca0_c98b_4946_9ac3_9b29b57f41bf, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Glady’s Ngugi(Beige Rafiki Dress)', '+254 722 368802', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":38,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-06-26 11:04:25.545+00', '2026-06-29', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_289382f2_fff3_413d_8709_b19fbbffe488, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Yvonne Wangui(Red Mini Party)', '0799600289', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3500, 3500, 7, '2026-06-30 15:36:36.367+00', '2026-06-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_29842f94_1ad9_4bdb_bd71_7299953026a7, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Kiprotich(Red Sonja Dress)', '0740432104', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-05-20 12:46:00.294+00', '2026-05-20', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_29bd86d7_611d_41ab_bd1e_9b9fc41d5797, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Kennedy(White cooperate & black rich aunty)', '0706 085 579', 'Dress', '"{\"Dress\":{}}"'::jsonb, 8700, 8700, 7, '2026-06-27 15:07:16.39+00', '2026-06-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_2a01f1d7_4a6d_4389_a151_47b2c25403e2, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Wendy Bosire(Black Sonja)', '0701584337', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":26,\"Hips\":37,\"Length\":39}}"'::jsonb, 3700, 3700, 7, '2026-04-16 08:17:10.395+00', '2026-04-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_2a87202c_0ed1_4da5_a8d1_b62219ac9a52, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Jacquline Muriithi(Navy Cooperate)', '0769947872', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0}}"'::jsonb, 4200, 4200, 7, '2026-02-11 07:10:35.536+00', '2026-02-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_2b490617_11c3_4aa7_857f_ec9437354b60, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Faith Kamau(Maroon Lily Dress & Hot Pink Boss Babe)', '0721642519', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":39,\"Waist\":34,\"Hips\":43,\"Length\":39,\"Sleeve\":24}}"'::jsonb, 7600, 7600, 7, '2026-02-18 15:53:57.893+00', '2026-02-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_2bad0435_1614_44f1_a73b_85b99e47d913, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ruth Kamau(Maroon Lily Dress)', '0793018852', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":42,\"Length\":37}}"'::jsonb, 3700, 3700, 7, '2026-02-17 09:11:57.755+00', '2026-02-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_2d2cde47_49a7_4c24_b4f7_a8091ff2c599, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ashely Njambi(Maroon lily dress)', '0794240436', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32.5,\"Waist\":29,\"Hips\":40,\"Length\":34}}"'::jsonb, 3700, 3700, 7, '2026-06-10 10:41:47.265+00', '2026-06-15', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_2edc0c90_0ddd_44ec_9bd8_39ed5d739dbd, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Christine Agum(chocolate brown Mara Dress)', '‪+254 790 173446‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":23,\"Hips\":38,\"Length\":39}}"'::jsonb, 3500, 1500, 7, '2026-04-10 11:10:25.793+00', '2026-04-14', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_2fb322cd_1418_4839_a3f7_5ae44026781a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Precious Cynthia(Red Mini Party)', '0701756868', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":31,\"Hips\":40,\"Length\":34,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-06-22 15:40:35.976+00', '2026-06-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_30f41e72_1c85_459a_b005_1767dfd1203e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Margaret Wanjiru(Chocolate brown Rich Aunty Dress)', '0702226827 ', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":43,\"Length\":56}}"'::jsonb, 4500, 4500, 7, '2026-06-15 17:45:34.659+00', '2026-06-20', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_311299d8_f229_49e1_8122_ef4d74dbea85, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Leah Wanjiru(Lilac Sonja)', '0799226089', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-04-10 10:28:34.828+00', '2026-04-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_31c73b06_7406_42a1_b392_413fce055657, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Minayo Irine(Navy Cooperate)', '0795016933', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4200, 4200, 7, '2026-03-12 14:05:26.18+00', '2026-03-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_32971693_a74c_4d48_a189_fd079dba1aa6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lynnet Ongeri(Navy Mara,Tweed,Navy Cooperate,Red Mini Party)', '0702970585', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":30,\"Hips\":41,\"Length\":39,\"Sleeve\":23}}"'::jsonb, 15500, 15500, 7, '2026-01-31 14:43:54.697+00', '2026-02-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3387c183_ffb3_46b6_a7a3_d03bb748da5c, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Merab Jemutai(Beige Rafiki)', '‪+254 728 029452‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":31,\"Waist\":29,\"Hips\":39,\"Length\":34}}"'::jsonb, 3700, 1850, 1, '2026-06-29 14:15:42.405+00', '2026-07-01', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_33b19d16_8b05_494e_9787_66b53b65930e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Eunice Nkatha(Hot Pink Rafiki)', '‪+254 742 809628‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":42,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-03-17 14:04:50.088+00', '2026-03-20', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3448b53b_7832_4136_903d_554c40f9267d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Caroline Ndung’u(red sonja)', '0720030267', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":32,\"Hips\":43,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-04-05 06:20:56.543+00', '2026-04-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3482afba_01bc_4a9d_acda_11a75f11148a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Njuguna(Mini Party)', '‪+254111242326‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":29,\"Hips\":40,\"Length\":34}}"'::jsonb, 3500, 3500, 7, '2026-03-24 12:34:14.194+00', '2026-03-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_34ede3e6_03ad_4998_a845_4e956d4049ac, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Faith Sikuku(Black Mara Dress)', '‪+254 716 644354‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":40,\"Length\":35}}"'::jsonb, 3500, 3500, 7, '2026-03-06 11:17:02.937+00', '2026-03-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_353a301d_6989_451a_865f_a075708768ce, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Rose Wanjiru(Navy Pinstripe Kini Set)', '0795627933', 'Pant set', '"{\"Shirt\":{\"Shoulder\":16,\"Bust\":41,\"Bodice\":20,\"Waist\":38},\"Trouser\":{\"Waist\":37,\"Hips\":47,\"Thigh\":31,\"Crotch\":31}}"'::jsonb, 4700, 4700, 7, '2026-03-21 10:09:03.638+00', '2026-03-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_36964c97_250e_4d1c_867b_072f52b1ef1a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Patrick Mungai', '0723288847', 'Pant set', '"{\"Shirt\":{},\"Trouser\":{}}"'::jsonb, 4700, 4700, 7, '2026-03-27 13:40:50.15+00', '2026-03-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_375a3d1b_b606_4907_bae7_1924e2493034, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Anne Kibei(Lilac Rafiki)', '0717448855', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-06-24 10:36:36.106+00', '2026-06-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_376209e8_9c96_41be_a0bc_28dd883cc40a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Zenaya(Black Mini Party)', '0703755703', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":44,\"Waist\":39,\"Hips\":49,\"Length\":39,\"Sleeve\":25}}"'::jsonb, 3500, 3500, 7, '2026-06-26 14:05:27.909+00', '2026-06-29', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_37a9d214_5b59_4dc3_8002_cc842a7d59da, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sophy Ndirangu(Red Sonja)', '0704431251', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":27,\"Hips\":39,\"Length\":40}}"'::jsonb, 3700, 3700, 7, '2026-03-30 08:56:45.032+00', '2026-04-02', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_37ba72c1_8280_4b59_9cd9_ba6c9e1eab28, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joan Mugure(Burgundy Mini party)', '‪+254 713 592386‬', 'Dress', '"{\"Dress\":{\"Shoulder\":18,\"Bust\":40,\"Waist\":33,\"Hips\":43,\"Length\":39}}"'::jsonb, 3500, 3500, 7, '2026-06-02 10:48:26.697+00', '2026-06-05', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_38aa44a8_4682_4980_a838_3b305615dcbf, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Rosemary Wangeci(Burgundy Sonja)', '0758906819', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33.5,\"Waist\":29,\"Hips\":45,\"Length\":36,\"Sleeve\":24}}"'::jsonb, 3700, 3700, 7, '2026-06-04 08:04:13.635+00', '2026-06-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3997f029_23d9_4ab0_8b52_ee512bffe7ac, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Fridah Mwongera(Rust Brown Backless)', '0795533627', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":26,\"Hips\":36,\"Length\":34,\"Sleeve\":25}}"'::jsonb, 3700, 3700, 7, '2026-03-16 13:54:14.31+00', '2026-03-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3b7785cf_2fed_4b3c_8c6b_def1f3acc699, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Emily Achieng(Red Rosê Maxi)', '0719589300', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":46,\"Waist\":36,\"Hips\":49,\"Length\":59,\"Sleeve\":26}}"'::jsonb, 4000, 4000, 1, '2026-06-13 09:34:03.463+00', '2026-06-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3bc18eda_fcbf_4f54_a3cd_47d1af2b1e27, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Chepkoech Stacy(lilac mini party)', '0728896430', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":31,\"Hips\":42,\"Length\":37}}"'::jsonb, 3500, 1750, 1, '2026-06-30 09:38:37.847+00', '2026-07-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3bc9e832_f5a4_401d_8fa5_f3b60019ec13, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Janice( Navy Blue Mara Dress)', '0795208786', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3500, 3500, 7, '2026-06-17 16:19:52.208+00', '2026-06-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3cbc6279_7bfb_42fa_b8d5_5d44346f11d6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Rotich(Burgundy Custom Order)', '‪+61 416 845 731‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":32,\"Hips\":43,\"Length\":56,\"Sleeve\":0}}"'::jsonb, 4500, 4500, 7, '2026-02-24 18:51:08.083+00', '2026-02-28', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3e396821_be2d_43f7_8a71_677ce1a442f9, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Esther Maina(Red sonja & Tweed Dress)', '0748717355', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":40,\"Length\":35}}"'::jsonb, 7900, 7900, 7, '2026-04-07 05:55:58.667+00', '2026-04-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3f02ebe6_f3cd_4341_b825_d392e5abdbe0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Daisy Mugo(Beige Rafiki)', '0717698573', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-04-03 14:36:26.462+00', '2026-04-03', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3f4313e9_07b6_4c8f_be4b_f49cba1b2872, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Eunice Mukuba(Red Chic Charm)', '0769183282', 'Dress', '"{\"Dress\":{\"Shoulder\":14,\"Bust\":33,\"Waist\":27,\"Hips\":36,\"Length\":36,\"Sleeve\":27}}"'::jsonb, 3500, 3500, 7, '2026-02-02 03:43:04.949+00', '2026-02-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3f4990d9_d1bf_4f4d_865c_72c50d27bb10, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sandra Gatwiri(Red Mini Party)', '0768124520', 'Dress', '"{\"Dress\":{\"Shoulder\":14,\"Bust\":33,\"Waist\":25,\"Hips\":37,\"Length\":32}}"'::jsonb, 3500, 3500, 7, '2026-06-15 13:19:50.507+00', '2026-06-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3fee883f_f1d0_487d_8d23_1abac51bf70d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Elizabeth wairimu(Beige Rafiki Dress)', '0768705759', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":40,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-06-09 12:01:08.272+00', '2026-06-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_3fef6309_97f9_4786_ab66_734ce3fd7d7e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Karemi (custom order)', '0707666744', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":38,\"Waist\":30,\"Hips\":47,\"Length\":57}}"'::jsonb, 1800, 1800, 7, '2026-05-04 09:40:50.311+00', '2026-05-15', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_41ad28d3_28e0_4d62_832e_d8fffdb4a847, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ferdinand Mang’eni(rex mini party)', '‪+254 748 250349‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":41,\"Waist\":34,\"Hips\":46,\"Length\":33,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-06-18 12:54:38.58+00', '2026-06-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_41b0f602_b136_4702_a000_f96a51a77693, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Samara Njeru(Burgundy Custom Order)', '0721109246', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":27,\"Hips\":38,\"Length\":32,\"Sleeve\":0}}"'::jsonb, 5500, 5500, 7, '2026-01-21 10:12:15.526+00', '2026-01-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_425f4714_ca96_417d_af0f_c98af89abf59, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Valary Opondo(Green Pinstripe & White Backless Maxi)', '0707190295', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":39,\"Length\":49}}"'::jsonb, 8500, 8500, 7, '2026-03-02 08:13:50.006+00', '2026-03-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_429ea2fa_65a0_4e0c_a828_f64d9e02acd5, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Catherine Githari(Beige Rafiki)', '‪+254 722 268761‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":27,\"Hips\":36,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-03-10 19:26:33.2+00', '2026-03-14', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_437b69fd_69ed_4ddb_ad56_4e22e0ee49a4, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Riziki Mwinyi(Custom corset dress)', '0718 148 505', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":41,\"Length\":60}}"'::jsonb, 7500, 7500, 7, '2026-05-11 11:09:40.214+00', '2026-05-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_4391054d_3169_49ab_b62b_7f75f3f534aa, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Peninah Maina(Red Lily Dress)', '0792601985', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":31,\"Waist\":24,\"Hips\":37,\"Length\":37}}"'::jsonb, 3700, 3700, 7, '2026-05-23 09:49:35.938+00', '2026-05-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_4405f45e_9552_4e65_bb2b_ecee6b36d025, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Emelda Marcos(maroon cooperate+ navy cooperate)', '0707064753', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":38,\"Waist\":32,\"Hips\":44,\"Length\":38,\"Sleeve\":27}}"'::jsonb, 8400, 8400, 7, '2026-01-10 15:00:21.421+00', '2026-01-15', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_443fcf26_babc_4086_9c05_fcc004b9f926, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Esthet Njuki(Black Kini Pant Set)', '‪+254 708 328 936‬', 'Pant set', '"{\"Shirt\":{\"Shoulder\":15,\"Bust\":33,\"Bodice\":18,\"Waist\":27},\"Trouser\":{\"Waist\":27,\"Hips\":44,\"Thigh\":26,\"Length\":40,\"Crotch\":27}}"'::jsonb, 4500, 4500, 7, '2026-06-24 11:39:11.157+00', '2026-06-25', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_46858bdb_80ad_45d0_8a7d_f2423052b76e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Yvonne Sunguti(Lilac Chic Charm,White Chic Dress & Mustard Maxi)', '0714676640', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":27,\"Hips\":39,\"Length\":27}}"'::jsonb, 12200, 12200, 7, '2026-03-06 15:50:41.878+00', '2026-03-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_471f49e8_14d8_411a_a83f_0e403595b815, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Noella Kagehi(Emerald green mara dress)', '0729697868', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":32,\"Waist\":28,\"Hips\":39,\"Length\":36}}"'::jsonb, 3500, 1750, 1, '2026-06-27 07:39:59.572+00', '2026-06-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_4851c661_1070_4925_b930_685d6c80aa20, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Stella Paul(Red Mini Party)', '0702144649', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":23,\"Hips\":38,\"Length\":35}}"'::jsonb, 3500, 3500, 7, '2026-05-30 09:17:14.255+00', '2026-06-01', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_48c2ed03_5414_4c24_9857_a8ed17c044df, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ruth Wang’ondu(lilac mini party)', '07182285169', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3500, 3500, 7, '2026-05-14 15:21:50.525+00', '2026-05-14', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_4989e9bb_d092_47a8_9760_37eec9dff252, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Abigael Chelangat(Red Sonja)', '0716918793', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":40,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-03-20 08:27:33.218+00', '2026-03-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_49da75db_91a6_4ef8_9009_1899e32178f8, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Nelly Mukami(Lilac Rafiki)', '0742897594', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 3700, 3700, 7, '2026-02-19 17:14:00.669+00', '2026-02-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_4d908ed0_f0c3_48c5_b88e_56428ec77fe9, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Jecinta Kamau(Burgundy sonja)', '0702256066', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-05-23 11:06:36.084+00', '2026-05-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_4f842ed5_049c_4760_a148_0f6e7a9fd388, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Esther Njuki(Green Skirt Set)', '0708328936', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":27,\"Hips\":44,\"Length\":25}}"'::jsonb, 4700, 4700, 7, '2026-06-10 10:18:02.589+00', '2026-06-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_4fbe841d_1e68_40e8_9a81_8701dbcbaecb, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Millicent Meja(Red Mini Party)', '0795018358', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":31,\"Hips\":44,\"Length\":55,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-01-10 14:28:47.848+00', '2026-01-10', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_4fe15d4e_ee02_45b3_9801_9af35c27570e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ruth Jelagat(Mini Party, Chic Charm & Mara)', '0792663291', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":27,\"Hips\":36,\"Length\":34,\"Sleeve\":27}}"'::jsonb, 10500, 10500, 7, '2026-01-17 11:51:22.101+00', '2026-01-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_52161fcb_317a_41e1_9f97_70261385b36c, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Faith Kasyoka(Navy blue chinese collar)', '0741096604', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39.5,\"Waist\":31,\"Hips\":43,\"Length\":40,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-02-10 10:40:42.621+00', '2026-02-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_528677f0_99bd_4ff0_b7dd_df2d6b7b6188, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Rose Ijimba(Burgundy Cooperate)', '‪+254 708 786980‬', 'Dress', '"{\"Dress\":{\"Bust\":40,\"Waist\":34,\"Hips\":41,\"Length\":41}}"'::jsonb, 4200, 2100, 7, '2026-04-11 12:41:06.068+00', '2026-04-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_52901161_b017_4eea_aef9_618f84b7e545, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Irene Kagunda(Red Mini Party)', '0795 468 619', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":41,\"Waist\":37,\"Hips\":45,\"Length\":37}}"'::jsonb, 3500, 3500, 7, '2026-04-21 10:12:57.303+00', '2026-04-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_53dbdaee_db5d_41a2_b0f4_f0bcf3be1d83, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Monica Mburu(Lilac Chic Charm)', '0713758963', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0}}"'::jsonb, 3500, 3500, 7, '2026-02-18 16:47:02.837+00', '2026-02-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5412c8fb_9740_4aaf_95d2_b6c3ec621a07, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Eunice Njoroge(Red will dress &chocolate brown rafiki)', '0724927669', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":34,\"Hips\":44,\"Length\":34,\"Sleeve\":26}}"'::jsonb, 7400, 7400, 7, '2026-02-02 14:11:10.148+00', '2026-02-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5454e22a_821a_44e9_afa4_07828b06a00b, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Anne Njoroge(Boss Babe)', '+254 737 415722', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":29,\"Hips\":43,\"Length\":40,\"Sleeve\":25}}"'::jsonb, 3700, 3700, 7, '2026-02-11 15:25:25.892+00', '2026-02-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_55aacc69_68c7_48d8_a662_f25b0b03ce49, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Hilda Wanjiku( Kini Set & Rich Aunty)', '0711162628', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":44,\"Length\":56,\"Sleeve\":12}}"'::jsonb, 9000, 9000, 7, '2026-01-17 10:16:03.047+00', '2026-01-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_55e127ad_33e3_4e8b_a119_f3a0db1c5fd4, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Claire Chepkemboi( Maroon Lily Dress)', '‪+254 794 037648‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":28,\"Hips\":38,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-05-09 09:50:32.352+00', '2026-05-14', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5697b913_2fb0_4559_ba97_430a7c7f56ca, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Hellen Mbalanya(White Mona Set)', '0721356257', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":43,\"Length\":57,\"Sleeve\":0}}"'::jsonb, 3950, 3950, 7, '2026-01-30 14:27:50.425+00', '2026-02-03', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_56c5cca7_5e8e_4216_bc03_a50bbc6178d9, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Melvin Ingado( Brown kini pants set)', '0753319877', 'Suit', '"{\"Coat\":{\"Shoulder\":0,\"Chest\":0,\"Bodice\":0,\"Waist\":0,\"Bicep\":0,\"Sleeve\":0,\"Length\":0,\"Hips\":0},\"Shirt\":{\"Shoulder\":17,\"Chest\":35.5,\"Bodice\":0,\"Waist\":28,\"Sleeve\":10,\"Length\":0,\"Neck\":0,\"Cuff\":0},\"Trouser\":{\"Waist\":28,\"Hips\":37.5,\"Thigh\":23,\"Knee\":0,\"Bottom\":0,\"Length\":42.5,\"Crotch\":28}}"'::jsonb, 4500, 4500, 7, '2026-02-27 11:52:26.732+00', '2026-03-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5706a438_9448_4283_9e93_9d03d3487387, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mary Moraa(Red Sonja)', '0768965394', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-06-08 16:11:52.413+00', '2026-06-08', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_57d1fa50_51df_4c56_af97_fe657f6db46a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Christine Karinten(Burnt Orange Maxi Rafiki)', '0707824925', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4500, 4500, 7, '2026-04-13 14:07:46.248+00', '2026-04-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_58387986_c2f4_48fb_9721_cc90a4936c05, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lydia Moraa(Mustard Mini Party)', '0799123484', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":40,\"Length\":38,\"Sleeve\":27}}"'::jsonb, 3500, 3500, 7, '2026-01-30 16:35:48.659+00', '2026-02-05', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5983e0fc_5714_44d8_b90d_8e3b530e212b, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Alice Muekau(Navy Blur Cooperate)', '0703298680', 'Dress', '"{\"Dress\":{\"Shoulder\":18,\"Bust\":46,\"Waist\":42,\"Hips\":52,\"Length\":43,\"Sleeve\":26}}"'::jsonb, 4200, 4200, 7, '2026-06-22 12:04:33.008+00', '2026-06-25', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5add4268_e2cd_4f2c_9f9a_57d673d222bf, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Susan Lung’aho(Zuri Dress)', '0724920456', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":44,\"Waist\":38,\"Hips\":47,\"Length\":43}}"'::jsonb, 4900, 4900, 7, '2026-06-24 11:49:03.519+00', '2026-06-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5b114319_7218_415b_9f72_7aeeb66b64fd, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Venny Amondi(Navy Blue, Pink pinstripe skirt)', '0742 560 336', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":27,\"Hips\":37,\"Length\":36}}"'::jsonb, 8400, 8400, 7, '2026-06-15 16:07:23.664+00', '2026-06-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5b15bc02_0ac0_435d_9843_0a93b1faa926, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Purity Chepkirui(Velvet Blended Corset)', '0718407735', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":32,\"Hips\":46,\"Length\":37}}"'::jsonb, 6500, 6500, 7, '2026-04-22 07:23:08.176+00', '2026-04-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5b487d29_8d17_4973_a4ba_7070366941e3, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Brenda Ouma(Red Rafiki)', '0741917285', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-04-04 11:33:17.397+00', '2026-04-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5c5d5520_c83e_4249_8022_58094bf80794, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Shelmith(White Chic Charm & Black A shape)', '‪+254 748 835524‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":29,\"Hips\":45,\"Length\":34,\"Sleeve\":27}}"'::jsonb, 7000, 7000, 7, '2026-02-09 07:01:26.498+00', '2026-02-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5cd9aea2_4ce0_4681_a00d_10b4e6820a98, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Georgette Thuku', '0726244037', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":40,\"Length\":57,\"Sleeve\":0}}"'::jsonb, 6000, 6000, 7, '2026-02-09 15:00:19.503+00', '2026-02-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5cde6ba5_95c7_4df0_a8e2_56b8ec4d0081, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Jenniffer Akinyi', '+254 724 944646', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 4000, 4000, 7, '2026-02-25 09:58:34.735+00', '2026-02-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_5dd8d2cd_ef81_4494_9caf_05555ba210c0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Damaris Wangeci(navy pinstripe,Kini Set)', '0701266072', '', '"{\"Shirt\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":30,\"Short Sleeve\":10,\"Length\":18},\"Trouser\":{\"Waist\":30,\"Hips\":41,\"Thigh\":26,\"Length\":43,\"Crotch\":28}}"'::jsonb, 4700, 4700, 7, '2026-03-14 11:42:21.653+00', '2026-03-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_60013079_a55d_4155_8e3b_af2da332ced8, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Christine Agum(Black Sonja)', '‪+254 790 173446‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":24,\"Hips\":38,\"Length\":40}}"'::jsonb, 3700, 3700, 7, '2026-04-08 07:02:02.542+00', '2026-04-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_612281e1_040d_409c_9a73_75e55a831601, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Marionnet Kerubo', '0724997298', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":41,\"Length\":35,\"Sleeve\":27}}"'::jsonb, 4200, 4200, 7, '2026-02-04 12:11:46.35+00', '2026-02-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6183e2ec_e0bd_4b32_995e_a60d46116da6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Faith Kiprop(Beige Rafiki)', '0113159797', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":33,\"Hips\":40,\"Length\":35,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-04-01 13:48:16.007+00', '2026-04-03', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_61860dd4_8965_4fef_aeb3_2a63dbb15d03, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mary Mrima(White Short sleeved mini party)', '‪+254 791 782801‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":26,\"Hips\":35,\"Length\":34,\"Sleeve\":25}}"'::jsonb, 3500, 3500, 7, '2026-06-04 16:31:46.883+00', '2026-06-09', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_61e1dc0e_95b1_4631_bfe0_140cb723735d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Fleviah Nyado(Navy Sonja Dress)', '‪+254 759 770028‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":25,\"Hips\":35,\"Length\":35,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-06-23 07:37:43.643+00', '2026-06-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_62434a1b_0461_461b_a378_53c38af5ba05, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Cheryl Musumba (Red Rafiki)', '‪+254 711 917678‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":28,\"Hips\":38,\"Length\":35,\"Sleeve\":27}}"'::jsonb, 3700, 3700, 7, '2026-02-11 08:30:52.298+00', '2026-02-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_625dca75_715a_42dc_a5d1_8633048ec197, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Stellar Ngina(Navy Blue Mini Party & Burgundy Sonja)', '0710847102', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":38,\"Length\":35}}"'::jsonb, 7200, 7200, 7, '2026-03-05 14:40:27.378+00', '2026-03-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_660eea38_841a_4654_a857_49b6739eb674, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Salome Wangari(P.Blue A shape,Burgundy Mini party)', '0711599331', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":41,\"Length\":36}}"'::jsonb, 7200, 7200, 7, '2026-06-11 12:16:27.075+00', '2026-06-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_66378964_5e20_49cf_b146_f5001352ef45, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Doris Mwema(Lilac Mini Party)', '0798450899', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":29,\"Hips\":40,\"Length\":35}}"'::jsonb, 3500, 3500, 7, '2026-06-24 14:08:54.753+00', '2026-06-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_66b0ea02_73db_43f3_9566_6304c75c95e6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Merina(Red Mona Set)', '0759299570', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3900, 3900, 7, '2026-04-13 14:14:25.965+00', '2026-04-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6799485b_6976_4e50_9e5f_54c614b2895a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Emily Achieng(Hot Pink Mona Set)', '‪+254 719 589 300‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":46,\"Waist\":36,\"Hips\":49,\"Length\":59}}"'::jsonb, 3950, 3950, 1, '2026-06-23 07:39:31.013+00', '2026-06-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_691595ad_1436_49da_8d21_fd9468670b75, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Jackline Kobia(Maroon Lily Dress)', '0718640804', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":27,\"Hips\":36,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-02-20 07:11:29.918+00', '2026-02-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6b15494f_fdeb_4e2c_83b2_e116ce746359, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Antonina Inyanji(J.Green Rafiki)', '0701038922', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":32,\"Hips\":45,\"Length\":35,\"Sleeve\":25}}"'::jsonb, 3700, 3700, 7, '2026-03-14 12:41:43.353+00', '2026-03-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6b1cafef_9ca9_46d4_bbab_df852c9936e4, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Beryl Juma(Red Mona)', '0768762466', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3950, 3950, 7, '2026-04-08 04:38:35.526+00', '2026-04-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6bd1b009_afde_471b_9a0a_5e5e4dc5f72d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Gabby Chebet(burgundy Sonja)', ' 0795022709', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-03-30 08:25:24.956+00', '2026-03-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6c3e54a1_1270_4ad5_9839_ab5ab310b98d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Melish(Black currant Rich Aunty Dress)', '0723873530 Melish Black currant rich aunty', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4500, 4500, 7, '2026-04-13 14:13:10.786+00', '2026-04-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6d7e80df_88e8_4f9f_a575_eb73b16b188e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joan Mugure(Tweed Dress)', '‪+254 713 592386‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":33,\"Hips\":43,\"Length\":39,\"Sleeve\":8}}"'::jsonb, 4500, 4500, 7, '2026-06-20 09:03:25.417+00', '2026-06-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6e9a3b25_b507_4ce7_a7b6_90033b854f47, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Karimi(custom chiffon dera)', '0707666744', 'Dress', '"{\"Dress\":{}}"'::jsonb, 1800, 1800, 7, '2026-05-04 17:36:55.099+00', '2026-05-15', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6ea0e5ce_0ecb_49ef_9248_0ab6ba1e5f01, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Riziki(Custom corset & skirt)', '+254 718 148 505', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":38,\"Waist\":32,\"Hips\":41.5,\"Length\":44,\"Sleeve\":26}}"'::jsonb, 7100, 7100, 7, '2026-01-28 15:43:05.087+00', '2026-02-03', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6ed7640a_c3a0_432b_856a_ca63feddcc67, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Yvonne Kwamboka(Black kini pants set)', '0746550886', 'Coat', '"{\"Coat\":{\"Shoulder\":16,\"Chest\":33.5,\"Waist\":26,\"Sleeve\":10,\"Length\":17,\"Hips\":40}}"'::jsonb, 4500, 4500, 7, '2026-02-19 12:42:28.03+00', '2026-02-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_6f830b7b_295e_4e46_bf1c_050eb8d343f3, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Christine Zachary(Black Mini Party)', '0713864087', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":26,\"Hips\":40,\"Length\":36,\"Sleeve\":27}}"'::jsonb, 3500, 3500, 7, '2026-01-13 18:03:04.697+00', '2026-01-16', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_709dec22_5a7c_43d4_b477_0633488b1ecc, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Esther Njoki(red corset dress)', '0743067993', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 6500, 6500, 7, '2026-02-26 11:34:55.089+00', '2026-02-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_70a9b8ef_090e_48a3_926e_ef8f44a597b0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Blessing Inviolattah (Maroon lily dress)', '0710390490', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-03-07 11:07:02.196+00', '2026-03-07', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_71c540ea_44f7_4e7a_ab20_a2d025ab3182, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Chepkirui Purity(Navy Cooperate)', '0718407735', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":46,\"Length\":37}}"'::jsonb, 4200, 4200, 7, '2026-04-21 13:43:38.878+00', '2026-04-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_72f9a4b6_3777_411e_8309_27b7f3a4f996, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Stacy Achola', '0726306688', 'Dress', '"{\"Dress\":{\"Shoulder\":16.5,\"Bust\":35,\"Waist\":28,\"Hips\":42,\"Length\":38,\"Sleeve\":27}}"'::jsonb, 15000, 15000, 7, '2026-01-07 07:20:25.407+00', '2026-01-16', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_73c4746c_db36_44c2_89b1_fef3ed896943, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Monicah Bosibori(Red Sonja Dress)', '‪+254 790 215499‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":32,\"Waist\":25,\"Hips\":39,\"Length\":37}}"'::jsonb, 3700, 3700, 7, '2026-04-13 06:58:36.734+00', '2026-04-16', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_77c255a0_3976_437b_8615_da325d350b88, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sylvia Kyalo(Burgundy Lily Dress)', '0723084676', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":34,\"Hips\":49,\"Length\":35,\"Sleeve\":16}}"'::jsonb, 3800, 3800, 7, '2026-04-14 07:53:32.099+00', '2026-04-15', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_77e81e1a_1aff_4da0_9137_2c3562b244bc, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Redimeter Mwangu(White Blended Corset Dress)', '0791951403', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":26,\"Hips\":40,\"Length\":33}}"'::jsonb, 9000, 9000, 7, '2026-02-25 07:48:18.821+00', '2026-02-28', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_781de23c_a86c_48d1_bba6_71fe51a72ed6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Faith Njeri(Red Sonja Dress)', '0799604122', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":30,\"Hips\":39,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-05-07 12:57:46.875+00', '2026-05-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_7824a73a_3de9_4719_a37e_3e4b8c370cb5, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Tracy Zalo  (Red rafiki)', '0716850291', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-04-21 10:28:14.318+00', '2026-04-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_78406b3d_c539_4ff2_aa63_d645c8484110, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Caroline Muriithi(Black Chic Dress)', '0799900740', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4200, 4200, 7, '2026-04-21 08:55:28.047+00', '2026-04-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_78844f7c_db9e_403d_9167_727a35e4e7c9, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ivyne Kibet(Red Rafiki)', '0793326638', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":34,\"Hips\":42,\"Length\":38,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-02-13 11:41:05.271+00', '2026-02-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_78868fc0_7111_4df4_aaa8_98e98c830f29, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sharon Chepkoech(Lilac Boss Babe)', '0705519938', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":32,\"Hips\":42,\"Length\":36}}"'::jsonb, 3700, 3700, 7, '2026-03-24 14:59:45.612+00', '2026-03-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_78cdf8e7_2542_4cfa_b99a_0fb574a5bf10, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Collins Keya(red rafiki)', '0796499276', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":37,\"Length\":35,\"Sleeve\":24}}"'::jsonb, 3700, 3700, 7, '2026-02-17 12:13:17.895+00', '2026-02-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_79e4949a_2daa_46cb_b4e4_0761605c1be2, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Hannah Macharia(White Sonja Dress)', '‪+254 793 612504‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":32,\"Waist\":27,\"Hips\":39,\"Length\":34}}"'::jsonb, 3700, 3700, 7, '2026-05-01 15:27:43.72+00', '2026-05-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_7b0575ca_e267_4e88_8b40_05fd387fdb35, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Dinah Wanjiku(red mini party)', '‪+254 707 758590‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":44,\"Waist\":39,\"Hips\":50,\"Length\":36}}"'::jsonb, 3500, 3500, 7, '2026-06-25 06:30:35.727+00', '2026-07-01', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_7b83db63_5fbc_4d0e_9c4c_718a38a89ff8, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Diana Maina(Burgundy Sonja)', '0743482654', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":46,\"Length\":37}}"'::jsonb, 3700, 3700, 7, '2026-06-11 14:25:06.019+00', '2026-06-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_7c46a2dc_ea73_4490_bcb2_1820d12c4a00, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lavender Moll(Burgundy sonja dress)', '0112140090', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-05-07 15:40:48.434+00', '2026-05-07', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_7c584062_600d_426f_b6fb_dfe4f3019af6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Rotich(Red Sonja)', '0724695329', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":36,\"Waist\":28,\"Hips\":40,\"Length\":35,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-02-28 06:25:15.932+00', '2026-03-03', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_7c5d3448_fa66_4a5c_bf36_1e6bb02f6816, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Yvonne Mbugua(Beige Rafiki, Maroon Lily, Green Kini Set, P.Blue A shape)', '‪+254 746 063807‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":31,\"Hips\":39,\"Length\":32}}"'::jsonb, 15400, 15400, 7, '2026-05-19 10:25:22.69+00', '2026-05-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_7cd6c67b_7f77_4f33_878f_34d083f3d4a0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Hellen Ngaukono(Maroon mara dress)', '‪+254 707 482663‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":33,\"Hips\":43,\"Length\":35}}"'::jsonb, 3500, 3500, 7, '2026-05-15 08:44:52.272+00', '2026-05-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_7f6b6bbc_2106_49d4_9514_326c22273f8c, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Nelly Njire( Mini Party & Mara)', '‪0797218970‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":36,\"Waist\":28,\"Hips\":40,\"Length\":36,\"Sleeve\":27}}"'::jsonb, 7000, 7000, 7, '2026-01-29 09:34:06.992+00', '2026-01-31', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_804a16a7_1633_4e07_b3c3_7a54b7353ab0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Nduku(offwhite mona set)', '0114569254', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":32,\"Length\":39,\"Sleeve\":54}}"'::jsonb, 3950, 1975, 1, '2026-06-29 14:38:30.555+00', '2026-07-02', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_80de5f40_2116_4c13_91fe_b4e36f63e827, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joan Kinaro( Red Mini Party)', '0748484469', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 3500, 3500, 7, '2026-02-09 08:16:48.672+00', '2026-02-09', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_81588e07_d811_411c_bd76_e0c0241f5502, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Kate Kendi(white cooperate)', '0743108762', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":30,\"Hips\":41,\"Length\":37,\"Sleeve\":25}}"'::jsonb, 4200, 4200, 7, '2026-06-23 09:50:17.647+00', '2026-06-29', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8261b4d3_9c5a_4a02_ac60_55338eebbe92, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Vivian Maina( Maxi black)', '0708162340', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":43,\"Waist\":41,\"Hips\":52,\"Length\":60}}"'::jsonb, 3900, 3900, 7, '2026-06-16 09:31:20.961+00', '2026-06-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_82b93d86_6cb4_4d7b_a7d9_ba7bf284e29d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sherlene Macharia(emerald green rose maxi)', '0769001555', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":31.5,\"Waist\":26,\"Hips\":37.5,\"Length\":52,\"Sleeve\":19}}"'::jsonb, 6250, 6250, 7, '2026-02-23 11:48:47.342+00', '2026-02-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_82df5a29_2b2b_4d88_b3ff_c51eb6bd4f9f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ashley Alinga(White Pinstripe skirt set)', '0740 462 535', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37.5,\"Waist\":29,\"Hips\":38,\"Length\":19}}"'::jsonb, 4700, 4700, 7, '2026-06-03 11:50:48.866+00', '2026-06-09', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_82f59488_fd69_4905_ba60_5d33795556d0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sharon Soila(Brown Kini Set)', '0718414903', 'Suit', '"{\"Coat\":{},\"Shirt\":{\"Shoulder\":15,\"Chest\":36,\"Waist\":29,\"Length\":18},\"Trouser\":{\"Waist\":29,\"Hips\":40,\"Thigh\":25,\"Crotch\":29}}"'::jsonb, 4500, 4500, 7, '2026-03-03 11:05:17.026+00', '2026-03-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8521ee7e_4b34_4ff3_a4d9_f5f8fd3a874d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Irene Njeri(Beige Rafiki)', '0795011385', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":27,\"Hips\":39,\"Length\":35,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-06-22 15:43:21.383+00', '2026-06-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8544e6c6_ba3f_4da3_94a0_9e0dc55eae34, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Isabel Wandia(Navy Cooperate)', '0792509066', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":29,\"Hips\":39,\"Length\":39}}"'::jsonb, 4200, 4200, 7, '2026-03-17 15:11:26.332+00', '2026-03-20', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_858aa9c0_3417_44c5_8ced_1228e1add8aa, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Shirleen Nyambura(Ocean Blue & Navy blue Blazer dress)', '0711289292', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":38,\"Waist\":34,\"Hips\":48,\"Length\":43,\"Sleeve\":24}}"'::jsonb, 11000, 11000, 7, '2026-02-17 11:06:59.501+00', '2026-02-20', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_868c6bd5_126b_496f_9a24_705aae5adc14, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Janejaquelyne(Tweed Dress)', '‪+254 719 187697‬', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4900, 4900, 7, '2026-06-23 12:56:00.192+00', '2026-06-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_88c99709_07da_47d8_9976_71e776424619, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Florence Sidi(Parliament Blue A shape)', '0791430901', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":38,\"Waist\":34,\"Hips\":44,\"Length\":36}}"'::jsonb, 3700, 3700, 7, '2026-05-30 09:59:05.505+00', '2026-06-02', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_88f41f16_f715_4575_9f95_dd0685dfd8eb, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Fifi(Lilac Rafiki Dress)', '‪+254106965313‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":28,\"Hips\":38,\"Length\":38,\"Sleeve\":23}}"'::jsonb, 3700, 3700, 7, '2026-06-04 16:00:55.49+00', '2026-06-09', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8950f0ae_c2f1_4030_a24a_504aae3a7fb5, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joyce Mathenge(Black Maxi Dress)', '‪+254 740 906895‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":29,\"Hips\":40,\"Length\":55}}"'::jsonb, 4500, 4500, 7, '2026-04-06 11:05:49.683+00', '2026-04-08', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_89b59b57_aa1b_4ee7_9edc_bf580b89b3db, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Petronilla Mbengei(Green Kini pant set)', '0790304249', 'Pant set', '"{\"Shirt\":{\"Shoulder\":16,\"Bust\":39,\"Bodice\":17,\"Waist\":34,\"Short Sleeve\":8,\"Length\":17},\"Trouser\":{\"Waist\":34,\"Hips\":47,\"Thigh\":24,\"Length\":43}}"'::jsonb, 4900, 4900, 7, '2026-06-23 09:33:14.389+00', '2026-06-29', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8a5e9bf5_9f1f_4230_93bd_1ce79c06f092, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sandra Okatch(Plain & J.Green Kini pant sets)', '0726326542', 'Pant set', '"{\"Shirt\":{\"Shoulder\":16,\"Bust\":43,\"Bodice\":17,\"Waist\":40},\"Trouser\":{\"Waist\":40,\"Hips\":50,\"Thigh\":33,\"Length\":44,\"Crotch\":33}}"'::jsonb, 9200, 9200, 7, '2026-05-19 04:23:45.627+00', '2026-05-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8d19aef8_85dd_4b19_b358_9661f224b12b, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Emmaculate Muriithi', '0715479387', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 6500, 6500, 7, '2026-02-10 11:48:23.383+00', '2026-02-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8d3f6d93_8b43_45cb_8ee2_261fcda8d7a6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lynet Wanjiku(Red Sonja)', '0758 963 614', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":42,\"Length\":40}}"'::jsonb, 3700, 3700, 7, '2026-06-09 06:45:51.558+00', '2026-06-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8d7a8a39_3bbf_46f0_8db8_6399b0419819, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Diana Mashebi(Velvet Blended corset Dress)', '0715707297', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":25,\"Hips\":37,\"Length\":37}}"'::jsonb, 6500, 6500, 7, '2026-04-18 11:46:32.111+00', '2026-04-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8d7f8b0f_e3e8_47ec_be33_4827e10673db, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Rose Mwendwa(Red Mini Party)', '0110839077', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3500, 3500, 7, '2026-06-13 13:35:28.899+00', '2026-06-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8e4e60a5_2027_4a84_9271_635b2347da03, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Maggy Wambui(2 black Rich Aunty Dresses)', '0707452555', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":43,\"Waist\":39,\"Hips\":48,\"Length\":59}}"'::jsonb, 9000, 3500, 1, '2026-06-13 12:41:47.479+00', '2026-06-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_8f6f90d1_71e3_41d1_94cf_8380f293a753, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lydia Lumumba(Maroon cooperate)', '‪+254 798 513787‬', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4200, 4200, 7, '2026-04-11 09:32:30.919+00', '2026-04-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_911d4d60_e960_4dcd_9438_2fd16672fe2d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mitchel Naomi(Navy Mini Party)', '0115563311', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3500, 3500, 7, '2026-03-21 14:56:45.994+00', '2026-03-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9122c1d8_94ef_4e6d_af48_41aa9298a366, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Emmaculate Peter( Burgundy Sonja)', '‪+254113006128‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":32,\"Waist\":28,\"Hips\":36,\"Length\":37}}"'::jsonb, 3700, 3700, 7, '2026-04-07 18:21:35.724+00', '2026-04-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_92ecfbdb_2247_4938_8a3e_c55e724e13b9, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joy Kinaga(Tweed & Longsleeve Backless)', '0729 282 296', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":42,\"Length\":36,\"Sleeve\":27}}"'::jsonb, 8200, 8200, 7, '2026-01-29 09:41:26.028+00', '2026-01-31', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_92f372aa_48ad_4fed_944c_055b78d476cf, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sharil Kipsosion(Burgundy Sonja)', '0790585305', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":31,\"Hips\":40,\"Length\":35}}"'::jsonb, 3700, 1850, 1, '2026-06-29 11:13:50.466+00', '2026-07-01', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9604b4e7_c559_47dc_9ec4_0c3224c0586e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Donna Otieno(Red Sonja Dress)', '‪+254 769 254745‬', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-06-14 07:47:12.535+00', '2026-06-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9647382e_e309_432e_9bb4_d98c089da0ae, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Jackline Muthoka(Ankara Dress', '+254 713 284 154', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":34,\"Hips\":0,\"Length\":37,\"Sleeve\":0}}"'::jsonb, 4000, 4000, 7, '2026-02-26 16:39:23.038+00', '2026-02-26', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9682092d_8b58_47cc_b8e7_9b3a0a2048a6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lilian Wanjiru(Red Sonja,Navy Cooperate, Maroon Cooperate)', '0799776069', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":42,\"Length\":37,\"Sleeve\":27}}"'::jsonb, 12100, 12100, 7, '2026-02-03 10:16:07.226+00', '2026-02-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_97d156f9_3973_4190_95c2_3e3ef95f9d2c, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sharon Eris(Burgundy Sonja)', '0740630027', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-06-30 14:44:09.438+00', '2026-06-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_97daf4f4_7475_46c4_a3eb_a1c13706b4ef, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Trista Chepkoech(Navy Cooperate)', '0794370407', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":41,\"Length\":35}}"'::jsonb, 4200, 4200, 7, '2026-05-26 12:29:31.172+00', '2026-06-01', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9886f983_4d56_4046_9382_cd8faa01bf5c, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Glady’s Mwihaki(Red chic charm)', '0798691340', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3500, 3500, 7, '2026-06-27 13:22:43.669+00', '2026-06-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9907dec6_d185_4f60_a32e_04f8f99383cc, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Glorias Jemutai(Burgundy Sonja Dress)', '0769704352', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":29,\"Hips\":45,\"Length\":34}}"'::jsonb, 3700, 3000, 1, '2026-06-30 11:16:05.966+00', '2026-07-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_991ded7f_c47d_457b_977a_75f06f924164, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Millicent Isaac(Burgundy cooperate)', '0715186195', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":27,\"Hips\":40,\"Length\":38}}"'::jsonb, 4200, 4200, 7, '2026-03-21 13:24:24.615+00', '2026-03-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_99259c02_9c66_4ba9_b3ad_d84d18fe8e3f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Doreen Magero(Red Rafiki)', '‪+254 759 003360‬', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":40,\"Waist\":39,\"Hips\":51,\"Length\":41}}"'::jsonb, 3700, 3700, 7, '2026-03-18 12:14:43.144+00', '2026-03-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9b99394f_dcb3_478d_965d_8964f9b52fee, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Naomi Esther(Maroon Pinstripe Maxi)', '0716221041', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":32,\"Hips\":41,\"Length\":57,\"Sleeve\":12}}"'::jsonb, 4700, 4700, 7, '2026-04-28 10:32:20.538+00', '2026-04-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9be5eead_6777_4870_b0bf_6ed9a569d97f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sarah Chepngetich(Beige A shape *2)', '0725937947', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":29,\"Hips\":39,\"Length\":35}}"'::jsonb, 7400, 7400, 7, '2026-05-20 14:12:02.156+00', '2026-05-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9d7f62ce_c8e5_486d_8022_f9f7a402e7e9, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Emily Kaweni(Maroon cooperate)', '0768486195', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":27,\"Hips\":41,\"Length\":35}}"'::jsonb, 4200, 2100, 1, '2026-06-29 14:40:55.245+00', '2026-07-02', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9da98588_ec9b_4022_9126_eb706555892b, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Abby Jane( Brown Sonja)', '0757642325', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":28,\"Hips\":39,\"Length\":35,\"Sleeve\":27}}"'::jsonb, 3700, 3700, 7, '2026-02-04 14:19:45.239+00', '2026-02-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9ddf5337_f404_4499_8297_9f4e22346934, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ashley Nadia(Navy Mini Party)', '0740276768', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3500, 3500, 7, '2026-05-13 16:53:41.688+00', '2026-05-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9f1a3225_c288_46dd_bea8_fc03f9ded09f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Grace Gitahi(Black Corseet)', '0790 942 115', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":34,\"Hips\":42,\"Length\":35}}"'::jsonb, 7500, 7500, 7, '2026-06-22 14:07:02.073+00', '2026-06-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_9f804260_235b_4866_bceb_9e0854b41bfa, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Shelmith (P.Blue A shape)', '0735403171', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":29,\"Hips\":45,\"Length\":33}}"'::jsonb, 3700, 3700, 7, '2026-04-18 11:36:53.819+00', '2026-04-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a1f6cc5a_b6ff_4bc4_9a2a_7c4a0cf14dd0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Scola Joseph(Red Mini Party)', '0757542373', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":24,\"Hips\":36,\"Length\":37,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-02-10 12:14:45.142+00', '2026-02-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a28626e1_b94e_4dc2_a840_ba6a2e553b52, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Peninah Mbiu(B.Pink Mona Set)', '0796906267', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":41,\"Length\":56}}"'::jsonb, 3950, 3950, 7, '2026-02-05 09:33:09.686+00', '2026-02-09', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a37e94b7_4cce_432f_b938_782fe963a7eb, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Petronila Mbengei(lilac rafiki & Navy maxi pinstripe)', '0790304249', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":28,\"Hips\":40,\"Length\":39,\"Sleeve\":25}}"'::jsonb, 8400, 8400, 7, '2026-06-17 10:31:08.795+00', '2026-06-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a3cc2eed_d392_4e5f_be80_43951e812cba, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Doreen Chebet(Pink skirt set)', '0706 377 357', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":41,\"Waist\":39,\"Hips\":45,\"Length\":20,\"Sleeve\":26}}"'::jsonb, 4700, 4700, 7, '2026-06-17 10:10:23.385+00', '2026-06-20', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a3fb828b_7ca8_4d33_b6a7_c1c4b403ec2e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Megan Kweyu(Red Mini Party', '0748120316', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 3500, 3500, 7, '2026-02-18 10:10:55.049+00', '2026-02-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a40235af_9568_4d59_9ead_9cd613a6c9f2, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Baby(Burgundy Custom)', '+254 790 680453', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":26,\"Hips\":38,\"Length\":32,\"Sleeve\":27}}"'::jsonb, 3800, 3800, 7, '2026-02-09 07:54:17.799+00', '2026-02-14', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a47bd80b_1ae8_4572_986c_8b39290b45c4, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Zuni Achila(Red Lily Dress)', '0720538149', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":32,\"Hips\":41,\"Length\":39}}"'::jsonb, 3700, 3700, 7, '2026-06-11 11:39:15.738+00', '2026-06-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a4f09ca1_5b41_419f_ab29_c74d830d0cc9, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Yvette Mboya(Custom Corset )', '0712 599 254', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":32,\"Hips\":43,\"Length\":37}}"'::jsonb, 7500, 7500, 7, '2026-03-05 07:28:16.705+00', '2026-03-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a4f38966_f52e_4828_9fad_27ba98864fc5, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Teresia Chege (4 custom outfits)', '‪+254 723 810717‬', 'Dress', '"{\"Dress\":{}}"'::jsonb, 30000, 30000, 7, '2026-04-16 08:07:27.556+00', '2026-04-17', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a53fa1bf_5d85_4dbb_8d49_e02f709520f5, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Iscah Odhiambo(Burgundy Sonja)', '0110499588', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":44,\"Length\":39}}"'::jsonb, 3700, 1850, 1, '2026-06-30 15:08:44.309+00', '2026-07-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a6a22c6b_6bec_44a9_b342_1abf4094591a, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Stephanie Achieng(Rafiki & Mini Party)', '0707896952', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":31,\"Hips\":43,\"Length\":39,\"Sleeve\":26}}"'::jsonb, 7200, 7200, 7, '2026-01-08 16:07:07.822+00', '2026-01-13', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a805c5d3_c331_4165_b3e4_6f8a013e1622, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Were(Red Sonja)', '0707384788', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-04-18 10:47:06.912+00', '2026-04-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a9368b86_daef_418c_985b_14b8ef8be401, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Catherine Wambua(Navy Sonja Dress)', '0715599088', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":32,\"Hips\":49,\"Length\":38}}"'::jsonb, 3700, 3700, 7, '2026-03-15 08:58:37.637+00', '2026-03-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_a97db74f_f2ed_46cc_aae9_7b4661cd79cb, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Rebecca Kibos(Ankara Custom Order)', '‪+61 430 093 583‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":33,\"Hips\":42,\"Length\":14}}"'::jsonb, 7500, 7500, 7, '2026-03-04 06:45:48.505+00', '2026-03-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_aa319382_afe7_4500_afa3_53c1072264cd, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Juliet Nyambura(Navy Mini Party)', '0798207431', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 3500, 3500, 7, '2026-02-17 13:28:51.344+00', '2026-02-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ab0d4683_d837_495a_8c13_bd9c6f09855e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ruth Jepchirchir(Red Rafiki Dress)', '‪+254 797 679330‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":33,\"Hips\":45,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-06-12 18:22:23.015+00', '2026-06-16', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ac11b3b2_536a_4fa0_a59c_10245558fa35, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Riziki Iddi(Custom burnt orange Dress)', '‪+254 718 148505‬', 'Dress', '"{\"Dress\":{}}"'::jsonb, 15000, 15000, 7, '2026-05-07 06:31:37.211+00', '2026-05-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ac8c5685_79b7_4431_bcb6_b8bbe2a5ef01, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Naomy Jepkoech(Beige Mini Rafiki)', '‪+254 720 723712‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":26,\"Hips\":36,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-03-28 06:14:10.781+00', '2026-03-31', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_accba925_dd84_42dd_9e95_4d427cfc0ff7, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Antonellah Lokitela (kini pant set)', '0758072074', 'Suit', '"{\"Top\":{\"Shoulder\":16,\"Chest\":35,\"Waist\":30,\"Hips\":41.5},\"Trouser\":{\"Waist\":30,\"Hips\":41.5,\"Thigh\":26,\"Length\":45,\"Crotch\":29}}"'::jsonb, 4500, 4500, 7, '2026-01-30 12:17:32.706+00', '2026-02-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_adfd2172_08cc_4db6_a736_abac7938d514, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Freida Cherus(Maroon Cooperate)', '0713682610', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":38,\"Waist\":33,\"Hips\":44,\"Length\":38}}"'::jsonb, 4200, 4200, 7, '2026-06-01 06:21:54.411+00', '2026-06-05', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ae1f8f0c_7d64_473c_afd4_a2d5f031cce2, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Jackline Moina(Red sonja & Navy Pinstripe)', '0798985496', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":31,\"Hips\":38,\"Length\":40}}"'::jsonb, 8400, 8400, 7, '2026-05-01 11:53:27.831+00', '2026-05-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_aeb95683_91f5_49e2_adf9_f4314ff556dc, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Stephanie Jackino(Black Mini Party)', '‪+254 708 730247‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":34,\"Hips\":44,\"Length\":39,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-06-17 16:14:43.175+00', '2026-06-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_aece34a9_9104_4573_9f65_985141f19357, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ednah Njoki(White Pinstripe, Mini Party)', '0115929244', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":29,\"Hips\":40,\"Length\":36,\"Sleeve\":26}}"'::jsonb, 4200, 4200, 7, '2026-03-03 14:27:26.777+00', '2026-03-09', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_aefbd269_d04d_4399_87ea_a8fe803e89dd, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Jane Wahu(Navy Cooperate)', '0798040533', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":42,\"Waist\":36,\"Hips\":52,\"Length\":40}}"'::jsonb, 4200, 4200, 7, '2026-06-16 12:19:26.324+00', '2026-06-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_af0ee547_3c32_4039_bbf7_2c892f312963, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Jane Akinyi(Burgundy Sonja Dress)', '‪+254 715 816655‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":29,\"Hips\":42,\"Length\":37,\"Sleeve\":25}}"'::jsonb, 3700, 3700, 7, '2026-06-16 13:45:12.051+00', '2026-06-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_af476951_900f_4d9c_822f_d94015053f71, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Gladys Nyagaka(Red Rosè Maxi)', '‪+254112576265‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":43,\"Waist\":34,\"Hips\":49,\"Length\":55,\"Sleeve\":26}}"'::jsonb, 4000, 4000, 7, '2026-06-11 11:27:54.199+00', '2026-06-16', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b07eea9b_b3ac_48fa_93a0_e4671ca500b5, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mary Micere(cream white lily dress+ blazer)', '+254 732 495791', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":35,\"Hips\":47,\"Length\":40}}"'::jsonb, 5500, 5500, 7, '2026-03-28 17:44:48.731+00', '2026-03-31', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b0c23acf_2622_4fde_81de_793d8e524a7d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Kisu(Burgundy Maxi Backless)', '0719424808', 'Dress', '"{\"Dress\":{\"Shoulder\":14,\"Bust\":32,\"Waist\":25,\"Hips\":40,\"Length\":57}}"'::jsonb, 3500, 3500, 7, '2026-05-27 10:26:07.015+00', '2026-06-02', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b106bf8a_f444_497e_9a28_e51c0584de02, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Susan Wambui(Red Sonja Dress)', '0743078617', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":29,\"Hips\":42,\"Length\":37,\"Sleeve\":27}}"'::jsonb, 3700, 3700, 7, '2026-02-09 10:42:37.547+00', '2026-02-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b19018d6_fe68_4d0b_bf33_49fe7dbc2a17, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Antonella Lokoro(Hot Pink Maxi Dress)', '0758072074', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":42,\"Length\":55}}"'::jsonb, 3900, 3900, 7, '2026-03-03 11:06:58.848+00', '2026-03-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b47e1c5e_ded4_482e_8068_fe426bd62aad, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Akoth(Brown Kini Pant Set)', '0799370927', 'Pant set', '"{\"Shirt\":{},\"Trouser\":{}}"'::jsonb, 4500, 4500, 7, '2026-06-02 13:47:33.879+00', '2026-06-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b6bb2e2b_a9e6_4cef_87f2_318839f642d3, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Cesna Ayieko(Burgundy Cooperate)', '‪+254 796 962631‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":43,\"Length\":35}}"'::jsonb, 4200, 4200, 7, '2026-04-22 09:35:22.848+00', '2026-04-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b6e3899c_1998_4527_8aa0_d70b3256c0e7, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Grace Wangeci(Burgundy Sonja)', '0112287115', 'Dress', '"{\"Dress\":{\"Shoulder\":14,\"Bust\":30,\"Waist\":26,\"Hips\":38,\"Length\":33}}"'::jsonb, 3700, 3700, 7, '2026-06-23 12:34:08.185+00', '2026-07-01', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b7705875_6b63_4e62_9151_f1ceef5b92e7, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Abigael(Red Sonja Dress)', '0715342363', 'Dress', '"{\"Dress\":{\"Shoulder\":18,\"Bust\":45,\"Waist\":35,\"Hips\":50,\"Length\":38,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-02-21 07:49:20.208+00', '2026-02-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b78cf955_d66d_42d6_be32_0a267057e913, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Cynthia Cherotich(Red Longsleeved Backless)', '‪+254 714 208055‬', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":40,\"Waist\":33,\"Hips\":44,\"Length\":35,\"Sleeve\":27}}"'::jsonb, 3700, 3700, 7, '2026-02-09 12:49:49.073+00', '2026-02-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b7b011f3_f616_48ba_8bd4_7f1c0984517f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Hope Achieng(', '0703687845', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 1850, 1, '2026-06-29 14:33:01.25+00', '2026-07-02', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_b9d668b9_9762_48a0_9024_78113c559347, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Jecinta Akinyi(Beige Rafiki)', '0742454692', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":39,\"Length\":34}}"'::jsonb, 3700, 3700, 7, '2026-04-07 06:02:57.112+00', '2026-04-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_bb1c9fe9_9aa1_4b6c_9a57_c54576ed3e14, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Shaline Andhamo(Burgundy Rafiki)', '0700437836', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":41,\"Waist\":36,\"Hips\":49,\"Length\":41,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-03-25 09:48:19.257+00', '2026-03-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_bb35a857_08f1_41e3_a121_2440680ddd88, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Catherine Wambui(Tweed Dress)', '0715599088', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":39,\"Waist\":32,\"Hips\":47,\"Length\":39}}"'::jsonb, 4500, 4500, 7, '2026-03-25 14:31:42.961+00', '2026-03-28', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_bb8fd263_323a_4762_85f2_964a69a3f9fa, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Winnie Kimani(Hot Pink Backless)', '0795204395', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":38,\"Hips\":47,\"Length\":36,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-05-05 11:14:25.243+00', '2026-05-08', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_bc73605a_df11_49ee_bc70_b23c8a193f00, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Simon Ngoni( Maroon A shape)', '0712100260', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":26,\"Hips\":36,\"Length\":32}}"'::jsonb, 3700, 3700, 7, '2026-04-14 15:51:59.439+00', '2026-04-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_bdee4006_4124_4e6e_8217_dd20d8b98700, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sanvi(Black Chic Dress)', '‪+254 712 900005‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":37,\"Hips\":40,\"Length\":35,\"Sleeve\":8}}"'::jsonb, 4200, 4200, 7, '2026-06-17 08:41:32.12+00', '2026-06-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_be6f8d55_c5d7_44f9_b0fe_5201a3b3bbf0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Moureen Mosoti(burgundy rafiki)', '‪+254 714 524400‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":33,\"Waist\":28,\"Hips\":38,\"Length\":34}}"'::jsonb, 3700, 3700, 7, '2026-05-09 04:57:38.989+00', '2026-05-14', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_bf43df83_504a_4e4c_a028_92cc2eff10e7, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Bridgit Wafula(Custom order)', '+254 740 206796', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":31,\"Length\":45}}"'::jsonb, 6500, 6500, 7, '2026-02-25 10:01:44.324+00', '2026-03-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c02ea85e_e8e1_40a4_b2ab_f8850044d54c, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Esther Muiruri(Blush pink Mona Set)', '0700059510', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":36,\"Waist\":34,\"Hips\":42,\"Length\":53}}"'::jsonb, 3950, 3950, 7, '2026-06-01 09:14:36.489+00', '2026-06-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c0492aab_e819_4d8a_92fa_363554f590e0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Dickson Gichuki(red rafiki)', ' +254 701 772828 ', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 3700, 3700, 7, '2026-02-19 12:08:41.784+00', '2026-02-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c04c4f89_b82e_4145_a8ed_9fd36e808551, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Anne Gichini(Lilac Rafiki)', '‪+254 720 405290‬', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 3700, 3700, 7, '2026-02-07 14:34:17.419+00', '2026-02-07', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c145b544_232b_4c08_926f_e054a68647df, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joan Njuguna(red mini party)', '0722265608', 'Dress', '"{\"Dress\":{\"Shoulder\":19,\"Bust\":47,\"Waist\":43,\"Hips\":48.5,\"Length\":44,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-06-23 11:57:28.401+00', '2026-06-29', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c4100220_789a_4861_bb1a_d7d7ddca83cc, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Priscilla Mwaniki', '0729886822', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":31,\"Waist\":24,\"Hips\":36,\"Length\":55,\"Sleeve\":10}}"'::jsonb, 4700, 4700, 7, '2026-01-19 07:11:02.538+00', '2026-01-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c45bbf5f_b432_4912_af20_d15a24cfcec6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Cadlar Juma ( white backless longsleeve)', '0725094902', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":26,\"Hips\":38,\"Length\":36,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-02-02 14:14:06.028+00', '2026-02-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c5455c86_d08c_433f_a864_03465bc82262, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Nyairo Kemunto(Black Rich Aunty)', '0745 524 366', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4500, 4500, 7, '2026-06-29 16:03:42.2+00', '2026-06-29', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c61f3fd4_49c5_499d_b26a_1333637d8c82, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joy Otieno(Black Rafiki)', '‪+254 743 633628‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":25,\"Hips\":33,\"Length\":33}}"'::jsonb, 3700, 3700, 7, '2026-03-11 08:53:48.413+00', '2026-03-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c7b05f3f_351b_4020_85d3_c3599362d243, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Immaculate Babalanda(Maroon Sonja Dress)', '‪+256 754 334010‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":43,\"Length\":39,\"Sleeve\":27}}"'::jsonb, 3700, 3700, 7, '2026-02-09 18:27:50.55+00', '2026-02-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_c9867a7f_463c_4172_b188_e7c396d5f791, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Vivian Ayuma(Button Down Tweed ć Buckle)', '0791650470', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":37,\"Hips\":48,\"Length\":45,\"Sleeve\":10}}"'::jsonb, 4200, 4200, 7, '2026-05-02 13:44:15.486+00', '2026-05-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_cc1ff338_f6bd_4a87_8d94_1e131a7ca25e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Kibuku Michael( custom 2 piece)', '0711694260', 'Suit', '"{\"Coat\":{\"Shoulder\":21,\"Chest\":42,\"Bicep\":16,\"Length\":29,\"Hips\":44},\"Shirt\":{},\"Trouser\":{\"Waist\":40,\"Hips\":44,\"Thigh\":29,\"Knee\":18,\"Bottom\":13,\"Length\":38}}"'::jsonb, 7500, 7500, 7, '2026-05-05 15:51:54.175+00', '2026-05-09', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_cf92d330_89d8_4ea4_9b9d_222a91f522cc, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Diana Jemeli(Red Rosé)', '0113083117', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4000, 4000, 7, '2026-03-13 12:12:04.89+00', '2026-03-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_cf934039_36d0_44cc_a76e_0e76ae15ee04, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Shelmith(Black Pinstripe Pant set)', '0727 015 062', 'Pant set', '"{\"Shirt\":{\"Shoulder\":16,\"Bust\":37,\"Bodice\":19,\"Waist\":33},\"Trouser\":{\"Waist\":33,\"Hips\":45,\"Thigh\":30,\"Length\":39,\"Crotch\":29.5}}"'::jsonb, 4700, 3000, 1, '2026-06-29 14:53:29.861+00', '2026-07-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d09c6c70_cf9a_4e8a_a26b_0416cb01e121, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Martha Makovu(Burgundy Mini party)', '0792154155', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":45,\"Length\":38}}"'::jsonb, 3500, 3500, 7, '2026-05-28 15:27:28.12+00', '2026-06-02', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d2a6c846_4ad7_4b9a_9a5a_3fc8f56fed1a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Fridah Gatwiri(Brown Kini Pant Set)', '0795533627', 'Suit', '"{\"Coat\":{\"Shoulder\":16,\"Chest\":35,\"Bodice\":17,\"Waist\":28},\"Shirt\":{},\"Trouser\":{\"Waist\":27,\"Hips\":41,\"Thigh\":26,\"Crotch\":29}}"'::jsonb, 4500, 4500, 7, '2026-02-24 12:23:47.929+00', '2026-02-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d2cd0697_9374_41de_b487_b926fa687c63, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Miriam Mueni(Red Mini Party)', '0724051920', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":34,\"Hips\":48,\"Length\":37,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-06-22 10:58:44.272+00', '2026-06-25', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d2f81793_c3a4_475d_8c08_331bb0036ebd, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Victory Wamocho(Corset Dress)', '0748042122', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":32,\"Hips\":40,\"Length\":34,\"Sleeve\":27}}"'::jsonb, 13500, 13500, 7, '2026-02-25 16:00:42.374+00', '2026-02-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d3773cfd_58b3_46ce_b3ef_813c2043608e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joy Anne(Green Rafiki Dress)', '0740 244 403', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-06-30 13:42:14.011+00', '2026-06-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d389befa_eb54_4248_9683_d9bbc109fcfb, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Daisy Mugo(White Chic Dress)', '0717698573', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":29,\"Hips\":42,\"Length\":35.5}}"'::jsonb, 4200, 4200, 7, '2026-03-21 11:19:03.42+00', '2026-03-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d38bbc6e_cc01_4c79_8f44_f1febbd767dd, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Nicole Bosire(Beige Rafiki Dress)', '0707558231', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":32,\"Hips\":47,\"Length\":40}}"'::jsonb, 3700, 3700, 7, '2026-06-23 17:26:25.091+00', '2026-06-25', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d4079abd_86f7_4b24_85ff_b71e5b4ed5ad, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sharon Soila(navy blue mara and mini party dress)', '0718414903', 'Dress', '"{\"Dress\":{\"Shoulder\":14,\"Bust\":34.5,\"Waist\":29,\"Hips\":39,\"Length\":39,\"Sleeve\":26}}"'::jsonb, 7000, 7000, 7, '2026-01-26 09:43:46.858+00', '2026-01-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d58b52d9_9f36_49b2_afdf_6c326413a8e0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Nadine Murera (red sonja)', '0794101083', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-03-07 11:48:53.162+00', '2026-03-07', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d617c6f0_1cbc_4ab4_afa5_db3e1cf24c62, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Hannah Thaara(Tweed Dress, 2 Piece J.Green,skirt & blouse (2)', '0722940076', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":46,\"Waist\":44,\"Hips\":56,\"Length\":42,\"Sleeve\":27}}"'::jsonb, 19800, 19800, 7, '2026-02-04 14:33:41.472+00', '2026-02-10', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d73d75ff_8345_4c4d_9d2b_3d7e4dba0ae8, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Purity Muthoni(Navy Cooperate)', '0717159064', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 4200, 4200, 7, '2026-02-19 15:00:31.325+00', '2026-02-19', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d7b2547d_4563_4ec0_b43d_c9b2ce46aa38, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Felicity Ochieng(Black sonja)', '0104893503', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":30,\"Hips\":44,\"Length\":36}}"'::jsonb, 3700, 3700, 7, '2026-03-13 14:52:49.562+00', '2026-03-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d7f2515f_2fc7_4690_8f46_d18a13f0b2eb, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Angela Wambua(lilac sonja dress)', '0790943759', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":30,\"Hips\":40,\"Length\":37,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-02-18 12:06:42.193+00', '2026-02-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d8a7d739_4d2b_4de5_9bd7_2af5132502bf, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Brenda Gatwiri(Beige Mini Party)', '0706 492 583', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":34,\"Hips\":47,\"Length\":38,\"Sleeve\":25}}"'::jsonb, 3500, 3500, 7, '2026-06-17 08:31:07.603+00', '2026-06-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d8abce89_d595_4c52_b92a_6dfaf9cf407d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mary Nyambura(Beige Rafiki)', '0757885645', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-04-24 15:55:20.501+00', '2026-04-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d934c8a7_42ca_472d_b70b_70631e7bce0f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Abby Jane(Sky Blue Kini Set)', '0757642325', 'Suit', '"{\"Coat\":{\"Shoulder\":15,\"Chest\":32,\"Bodice\":15,\"Waist\":26,\"Bicep\":14,\"Sleeve\":8,\"Length\":16,\"Hips\":37},\"Shirt\":{\"Shoulder\":0,\"Chest\":0,\"Bodice\":0,\"Waist\":0,\"Sleeve\":0,\"Length\":0,\"Neck\":0,\"Cuff\":0},\"Trouser\":{\"Waist\":26,\"Hips\":37,\"Thigh\":27,\"Knee\":0,\"Bottom\":0,\"Length\":43,\"Crotch\":0}}"'::jsonb, 4500, 4500, 7, '2026-01-27 13:22:50.537+00', '2026-02-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_d9d70c11_c607_4bcd_ab38_c0159d56b14a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Judy Kioko(Red Rafiki)', '0746076117', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":37,\"Waist\":30,\"Hips\":39,\"Length\":33,\"Sleeve\":25}}"'::jsonb, 3700, 3700, 7, '2026-02-14 11:35:27.103+00', '2026-02-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_da0b50a1_679d_4598_9598_0dfcc381f733, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sharon Mongina(Red Mona Set)', '0769358616', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":25,\"Hips\":35,\"Length\":54}}"'::jsonb, 3950, 3950, 7, '2026-03-11 12:42:41.745+00', '2026-03-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_da1645e8_ab69_44a3_b80a_380403bed46f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Vivian Kemboi(Burgundy sonja dress)', '0717687493 ', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-05-28 10:00:57.06+00', '2026-05-28', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_db465ae5_b8f1_4245_9a02_34f41e61153a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Nadia Achieng(Black Maxi Rafiki)', '0115758663', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":38,\"Waist\":34,\"Hips\":40,\"Length\":57}}"'::jsonb, 4500, 4500, 7, '2026-04-16 15:28:53.967+00', '2026-04-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_dba22eed_2047_40d1_80d2_b0a59d6597b8, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joy Mwihaki(Sonja Dress)', '‪+254111757746‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":42,\"Length\":37,\"Sleeve\":23}}"'::jsonb, 3700, 3700, 7, '2026-06-07 16:02:04.477+00', '2026-06-09', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_dca13654_fd66_45be_bbef_6831d6f3839e, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lorraine Anyango(Lily Dress,Mini Party Dress,Rafiki Dress)', '0714036571', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":32,\"Waist\":28,\"Hips\":35,\"Length\":34}}"'::jsonb, 10900, 10900, 7, '2026-05-07 11:21:29.244+00', '2026-05-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_dd330e70_7144_44c8_b541_b670477163d0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Juliet Nyambura(navy blue mini party)', '0798207431 ', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3500, 3500, 7, '2026-02-17 13:26:18+00', '2026-02-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_dd74128e_2bec_4ed6_b749_2807c97cfe2b, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Bridgit Wafula', '+254 740 206796', 'Dress', '"{\"Dress\":{}}"'::jsonb, 11000, 11000, 7, '2026-06-13 14:33:14.529+00', '2026-06-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_dfcc12ab_1920_41a9_89df_7cfa22d9af44, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Anita Wandela(Black Lily Dress)', '0746 118 603', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":36,\"Waist\":31,\"Hips\":42,\"Length\":34,\"Sleeve\":26}}"'::jsonb, 3700, 5550, 7, '2026-06-15 14:34:15.209+00', '2026-06-18', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e0e25228_4dde_4f65_90b1_6692cb82b8d6, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Christine Adams(Zuri Dress)', '0703918280', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":32,\"Hips\":42,\"Length\":37}}"'::jsonb, 4900, 2450, 1, '2026-06-29 11:35:49.087+00', '2026-07-02', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e16beef0_f1c0_4f05_b4bd_01dc8506f561, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Winnie Cherop(Maroon Cooperate)', '0115740775', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":36,\"Length\":36}}"'::jsonb, 4200, 4200, 7, '2026-06-24 14:37:24.567+00', '2026-07-02', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e31fbc9b_3149_4782_acf8_9c291497b650, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Mercy Nduva(Mini Party ć details)', '0728983971', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":46,\"Waist\":40,\"Hips\":50,\"Length\":37}}"'::jsonb, 4000, 4000, 7, '2026-06-11 11:59:30.255+00', '2026-06-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e33ced74_93d4_4fa4_9a0c_0e95a0412669, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Brenda Omutule(Custom Corset)', '+254 724 324589', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":30,\"Hips\":39,\"Length\":59}}"'::jsonb, 14500, 14500, 7, '2026-03-26 12:38:26.225+00', '2026-04-07', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e4319103_6484_4571_a1ec_d714d2cfb084, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lucy Kimani(Burgundy Sonja)', '0743118397', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":31,\"Hips\":40,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-05-04 12:59:58.07+00', '2026-05-21', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e480a1aa_6e63_4ec0_9810_3a7b42f40bd5, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Antonellah Lokitela(red milele, turquoise will dress and navy maxi pinstripe)', '0758072074', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":30,\"Hips\":42,\"Length\":42,\"Sleeve\":10}}"'::jsonb, 11900, 11900, 7, '2026-01-20 11:23:49.305+00', '2026-01-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e4deadf4_bd02_4a34_a41c_92039c0ba013, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Cecilia Ombaiye(Red Sonja Dress)', '0728926277', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3700, 3700, 7, '2026-06-30 14:30:02.383+00', '2026-06-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e6cd6425_1b1e_48ad_9ce1_f011b42700b8, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Gloria Otieno(Maroon Sonja)', '‪+254 701 325812‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":42,\"Waist\":36,\"Hips\":46,\"Length\":38}}"'::jsonb, 3700, 3700, 7, '2026-05-23 06:23:31.66+00', '2026-05-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e6e932ee_6cb1_4972_8e9b_8fda8ca1fe10, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Rochelle Andrew(Hot Pink Backless', '0799988200', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":33,\"Hips\":43,\"Length\":35,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-04-02 12:48:16.889+00', '2026-04-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e7163579_254a_478e_bd48_5670febe6108, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lilian Owino(Mustard Maxi Dress)', '0717 610 307', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4500, 4500, 7, '2026-04-06 09:51:09.842+00', '2026-04-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e7384974_4bbf_452f_b639_e440091a1d18, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Beatrice Jepleting(Navy Blue Mara)', '0708709247', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 3500, 3500, 7, '2026-02-27 15:17:40.769+00', '2026-02-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e7a07563_ffb1_4f9e_8fe8_18b6ee4a5d2d, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Wangui Mwaniki(Navy Cooperate,Red Mini Party,Black Sonja,Kini Pant Set)', '0790475752', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":26,\"Hips\":37,\"Length\":38,\"Sleeve\":38}}"'::jsonb, 15500, 15500, 7, '2026-03-19 14:12:50.047+00', '2026-03-28', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e99e4999_929b_48c2_820f_337864586030, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Njoki Nginyi(Burgundy Sonja, Navy & Hot pink Custom)', '0716072278', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":29,\"Hips\":40,\"Length\":35,\"Sleeve\":26}}"'::jsonb, 14200, 14200, 7, '2026-04-03 08:08:42.755+00', '2026-04-08', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_e9cca742_cd11_4f21_b8ef_275ead8cee6f, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Mary Ngele( Turquiose Will Dress)', '0796245540', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":31,\"Waist\":27,\"Hips\":36,\"Length\":36,\"Sleeve\":25}}"'::jsonb, 3700, 3700, 7, '2026-02-02 06:32:32.771+00', '2026-02-06', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ea0ff900_5c06_4a3d_b41d_cd09463d8235, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Elsie Chemutai(Red Rosé Maxi)', '0726960898', 'Dress', '"{\"Dress\":{\"Shoulder\":14,\"Bust\":31,\"Waist\":24,\"Hips\":35,\"Length\":54,\"Sleeve\":23}}"'::jsonb, 4500, 4500, 7, '2026-05-30 10:25:17.541+00', '2026-06-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ea388d6b_8cbe_4839_bcf6_e61a54b366e7, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ruth (Black Custom Order)', '0705296530', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":38,\"Waist\":30,\"Hips\":42,\"Length\":57,\"Sleeve\":0}}"'::jsonb, 3700, 3700, 7, '2026-01-30 09:55:44.413+00', '2026-02-03', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ea3d6785_b3f6_4a28_84a6_f5c8c9cfafee, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Doreen Nekesa(Maxi Midi Sleeveless Dress)', '0743376238', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":28,\"Hips\":40,\"Length\":47}}"'::jsonb, 4500, 4500, 7, '2026-05-29 10:07:26.559+00', '2026-06-04', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ea6fb5b6_aa7e_439e_a17d_ad7354398615, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joy Kinaga(Custom White Dress)', '0729 282 296', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":34,\"Waist\":28,\"Hips\":40,\"Length\":35,\"Sleeve\":0}}"'::jsonb, 6200, 6200, 7, '2026-02-23 16:16:45.773+00', '2026-02-25', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ebf91396_e436_46e9_a28d_3b0a7eaa6811, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Damaris Kithinji', '0757918266', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":36,\"Waist\":29,\"Hips\":37,\"Length\":39}}"'::jsonb, 3700, 3700, 7, '2026-06-08 14:29:09.989+00', '2026-06-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_edf1a27c_72c2_4ad8_b066_7233353f567f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Nazeline Wanyika(Red Sonja)', '0702083828', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":33,\"Waist\":26,\"Hips\":40,\"Length\":35,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-02-23 10:28:56.687+00', '2026-02-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ee15ed87_711d_45bf_af52_76c54f841d9a, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Naomi Mwangi(Navy Cooperate)', '0758800595', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":40,\"Waist\":34,\"Hips\":49,\"Length\":40,\"Sleeve\":27}}"'::jsonb, 4200, 2000, 1, '2026-02-05 08:55:16.377+00', '2026-02-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_ef27d9a5_c1aa_477e_bcd2_4640e2dfe229, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Felista Annoh(Sky blue Skirt Set)', '0710308938', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":32,\"Waist\":30,\"Hips\":40,\"Length\":19}}"'::jsonb, 4700, 4700, 7, '2026-05-27 13:12:08.662+00', '2026-05-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f1af0790_134b_4fae_be53_44bc1776dad0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Susan Fip(Zuri Dress )', '0745680471', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":42,\"Waist\":36,\"Hips\":48,\"Length\":39,\"Sleeve\":6}}"'::jsonb, 4900, 2500, 1, '2026-06-23 13:58:08.781+00', '2026-07-01', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f1d260d7_73dd_4332_baa6_7d2fcda635ea, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Rose Chepkorir(Mustard rich aunty&red rafiki maxi )', '0705978045', 'Dress', '"{\"Dress\":{\"Shoulder\":15.5,\"Bust\":37,\"Waist\":31,\"Hips\":41,\"Length\":53,\"Sleeve\":21}}"'::jsonb, 9000, 9000, 1, '2026-06-23 10:42:51.799+00', '2026-07-01', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f1edefcd_ebb4_4b49_a346_10b6814f0689, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Faith Mwikali(Red Sonja Dress)', '0705210437', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":33,\"Hips\":44,\"Length\":39,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-02-20 15:49:38.81+00', '2026-02-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f26883c1_d830_4871_ab5b_d1b5a8fff409, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ann Maina(Maroon Cooperate)', '‪+254 711 978816‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":32,\"Waist\":27,\"Hips\":37,\"Length\":35,\"Sleeve\":24}}"'::jsonb, 4200, 4200, 7, '2026-06-01 08:23:01.834+00', '2026-06-05', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f2691492_ea8c_4b55_8319_fe0aa82c09d5, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lydia Moraa( Hot pink Boss Babe)', '0799123484', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":30,\"Hips\":40,\"Length\":38,\"Sleeve\":27}}"'::jsonb, 3700, 3700, 7, '2026-01-24 14:51:15.557+00', '2026-01-29', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f2ada1ba_4fd8_4f3d_bb20_c1a513f54c56, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Brian Bett(Kini Set, Navy Pinstripe)', '‪+254 728 085834‬', 'Suit', '"{\"Coat\":{\"Shoulder\":0},\"Shirt\":{},\"Trouser\":{}}"'::jsonb, 4700, 4700, 7, '2026-02-12 11:34:05.111+00', '2026-02-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f30fe4da_ef57_45e4_8cfc_159cc13df92f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'June Muringo(Lilac Rafiki Dress)', '0729772253', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 3700, 3700, 7, '2026-02-25 11:45:53.975+00', '2026-02-25', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f48a91fd_23bd_4163_8062_710857a88633, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Laureen Odhiambo(Chocolate brown backless mini)', '‪+254 706 789883‬', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":34,\"Waist\":28,\"Hips\":44,\"Length\":36}}"'::jsonb, 3700, 3700, 7, '2026-05-21 09:44:59.898+00', '2026-05-27', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f764f45a_6193_4d16_ac5c_2d3a345c37e4, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Natalia Jepkorir(Red Mona Set)', '0794492318', 'Dress', '"{\"Dress\":{}}"'::jsonb, 3950, 3950, 7, '2026-06-05 16:23:14.65+00', '2026-06-06', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f8f41fc4_5cd1_4cfb_b8b1_511377e97c26, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Phylis Lucy(Navy Blue Mini Party Dress)', '0707739212', 'Dress', '"{\"Dress\":{\"Shoulder\":0,\"Bust\":0,\"Waist\":0,\"Hips\":0,\"Length\":0,\"Sleeve\":0}}"'::jsonb, 3500, 3500, 7, '2026-02-25 13:47:58.276+00', '2026-02-25', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_f907fe28_822b_4ae6_b536_ca40d46f5eb3, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Dorothy Anunda( Burgundy Sonja Dress)', '0745304236', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":39,\"Waist\":32,\"Hips\":43,\"Length\":44,\"Sleeve\":26}}"'::jsonb, 3700, 3700, 7, '2026-06-13 12:27:01.631+00', '2026-06-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fa02ecff_3be5_4f97_875b_3d4cb1c1b818, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lynet Mwangi(lilac rafiki dress)', '‪+254 757 720725‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":41,\"Waist\":32,\"Hips\":43,\"Length\":36}}"'::jsonb, 3700, 3700, 7, '2026-05-11 14:36:45.079+00', '2026-05-15', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fa3b636b_038a_42c8_90fe_8e229e8ec0ae, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Ashley Odhiambo(Red Mini Party)', '0758434534', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":41,\"Waist\":34,\"Hips\":54,\"Length\":38}}"'::jsonb, 3500, 3500, 7, '2026-06-16 13:19:30.454+00', '2026-06-22', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fa720a5c_efca_48f8_a1e8_ede9c79c52b0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Petronilla Wanjiru(Navy Cooperate)', '0797793444', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":37,\"Waist\":29,\"Hips\":43,\"Length\":37,\"Sleeve\":26}}"'::jsonb, 4200, 4200, 7, '2026-06-20 12:17:37.732+00', '2026-06-24', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fb79ebce_ed8a_41a8_ada9_e12d3076f320, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Purity Njiri(Black Midi & Burgundy sonja)', '0714765013', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":38,\"Waist\":32,\"Hips\":45,\"Length\":45}}"'::jsonb, 9100, 9100, 7, '2026-04-11 15:19:51.368+00', '2026-04-17', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fbfffea4_6630_4551_bde1_39d21774d2cb, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Magdaline(Midi Dress, Brown Kini Pant Set,Tweed Zuri Dress)', '0797065171', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":39,\"Length\":38}}"'::jsonb, 14900, 14900, 7, '2026-06-09 12:15:01.218+00', '2026-06-13', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fd1a5bd6_3589_4045_8cb6_a04d0fd404d0, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Edith Maiyo(Parliament blue A shape)', '‪+254 711 140139‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":35,\"Waist\":28,\"Hips\":40,\"Length\":35}}"'::jsonb, 3700, 3700, 7, '2026-06-05 17:46:09.517+00', '2026-06-08', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fd3b5d5a_3e28_43a3_bbc1_e801909abce6, v_org_id, v_shop_3f934afc_4f24_46b2_a441_9da3161a98ea, v_manager_id, 'Mercy Sitienei', '0726366689', 'Dress', '"{\"Dress\":{\"Shoulder\":15,\"Bust\":35,\"Waist\":29,\"Hips\":39,\"Length\":38,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-01-05 15:41:19.065+00', '2026-01-08', '', v_worker_8b147cc6_8c39_4302_9bcd_02c31db7e10d, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fd7a3c78_a3b1_473c_99d2_3e6a68cc7b41, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Sonia Sanguli(white kini set)', '0112317237', 'Pant set', '"{\"Shirt\":{\"Shoulder\":16,\"Bust\":34,\"Bodice\":16,\"Waist\":34},\"Trouser\":{\"Waist\":26,\"Hips\":42,\"Thigh\":26,\"Length\":45}}"'::jsonb, 4500, 4500, 7, '2026-03-10 07:54:20.913+00', '2026-03-12', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fd94950c_fd6b_4be5_a231_bc2371db2946, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Verah Cherono(Corset Dress)', '‪+254112022415‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":36,\"Waist\":30,\"Hips\":42,\"Length\":37}}"'::jsonb, 6500, 6500, 7, '2026-03-23 11:49:25.91+00', '2026-03-26', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fe1afdcf_0fbe_4ce3_9087_05ec214db195, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Lydia Lumumba(Maroon Cooperate)', '‪+254 798 513787‬', 'Dress', '"{\"Dress\":{}}"'::jsonb, 4200, 4200, 7, '2026-05-30 10:46:34.266+00', '2026-05-30', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fe9812d5_312d_4adb_a15e_e538495e782f, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Joy Maritim(Navy Cooperate)', '0716700360', 'Dress', '"{\"Dress\":{\"Shoulder\":17,\"Bust\":44,\"Waist\":35,\"Hips\":47,\"Length\":43,\"Sleeve\":26}}"'::jsonb, 4200, 2100, 1, '2026-03-06 11:24:08.273+00', '2026-03-11', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);
INSERT INTO public.orders (id, organization_id, shop_id, manager_id, customer_name, customer_phone, garment_type, measurements_details, price, amount_paid, status, created_at, due_date, customer_preferences, worker_id, additional_workers) 
VALUES (v_order_fec347e8_9ce4_4bca_8e79_e7ee0fcbbb12, v_org_id, v_shop_51ec6df1_c2fb_4823_a31c_82f406563e67, v_manager_id, 'Carol Wangui(Red Mini Party)', '‪+254 792 230286‬', 'Dress', '"{\"Dress\":{\"Shoulder\":16,\"Bust\":42,\"Waist\":34,\"Hips\":44,\"Length\":40,\"Sleeve\":26}}"'::jsonb, 3500, 3500, 7, '2026-06-19 11:06:32.247+00', '2026-06-23', '', v_worker_116e3034_c23a_4bb6_8d26_7e4c0f1e89a0, '[]'::jsonb);

-- 8. Import Payments
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_92ecfbdb_2247_4938_8a3e_c55e724e13b9, v_manager_id, 4100, 'cash', '', '2026-01-31 14:50:50.271+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ea388d6b_8cbe_4839_bcf6_e61a54b366e7, v_manager_id, 2000, 'cash', '', '2026-01-30 09:55:46.908656+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8d19aef8_85dd_4b19_b358_9661f224b12b, v_manager_id, 6500, 'cash', '', '2026-02-10 11:48:25.172824+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_61e1dc0e_95b1_4631_bfe0_140cb723735d, v_manager_id, 2000, 'cash', '', '2026-06-23 07:37:44.763173+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_054e15de_3733_4e03_99b2_a994b362f130, v_manager_id, 1850, 'cash', '', '2026-05-29 15:45:00.836126+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3482afba_01bc_4a9d_acda_11a75f11148a, v_manager_id, 1750, 'cash', '', '2026-03-24 12:34:16.980547+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6d7e80df_88e8_4f9f_a575_eb73b16b188e, v_manager_id, 2250, 'cash', '', '2026-06-20 09:03:26.16188+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_80de5f40_2116_4c13_91fe_b4e36f63e827, v_manager_id, 3500, 'cash', '', '2026-02-09 08:16:50.474988+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a40235af_9568_4d59_9ead_9cd613a6c9f2, v_manager_id, 2300, 'cash', '', '2026-02-20 13:29:06.843+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fa720a5c_efca_48f8_a1e8_ede9c79c52b0, v_manager_id, 2100, 'cash', '', '2026-06-26 16:03:32.315+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ac8c5685_79b7_4431_bcb6_b8bbe2a5ef01, v_manager_id, 3700, 'cash', '', '2026-03-28 06:14:11.76923+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_77c255a0_3976_437b_8615_da325d350b88, v_manager_id, 2000, 'cash', '', '2026-04-14 07:53:33.635029+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b6e3899c_1998_4527_8aa0_d70b3256c0e7, v_manager_id, 3700, 'cash', '', '2026-06-23 12:34:09.268587+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_079030b9_cd99_434b_8980_c536f1fbff82, v_manager_id, 8725, 'cash', '', '2026-06-02 14:51:02.673516+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2a01f1d7_4a6d_4389_a151_47b2c25403e2, v_manager_id, 1850, 'cash', '', '2026-04-16 08:17:11.159189+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f2691492_ea8c_4b55_8319_fe0aa82c09d5, v_manager_id, 2000, 'cash', '', '2026-01-24 14:51:16.572693+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_29bd86d7_611d_41ab_bd1e_9b9fc41d5797, v_manager_id, 8700, 'cash', '', '2026-06-27 15:07:18.216131+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_88c99709_07da_47d8_9976_71e776424619, v_manager_id, 3700, 'cash', '', '2026-05-30 09:59:06.373899+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2b490617_11c3_4aa7_857f_ec9437354b60, v_manager_id, 3600, 'cash', '', '2026-02-21 11:58:57.39+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_92ecfbdb_2247_4938_8a3e_c55e724e13b9, v_manager_id, 4100, 'cash', '', '2026-01-29 09:41:26.964289+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_89b59b57_aa1b_4ee7_9edc_bf580b89b3db, v_manager_id, 2450, 'cash', '', '2026-06-23 09:33:16.083012+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ea3d6785_b3f6_4a28_84a6_f5c8c9cfafee, v_manager_id, 2250, 'cash', '', '2026-05-29 10:07:28.043657+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4f842ed5_049c_4760_a148_0f6e7a9fd388, v_manager_id, 4700, 'cash', '', '2026-06-10 10:18:03.13826+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7cd6c67b_7f77_4f33_878f_34d083f3d4a0, v_manager_id, 1750, 'cash', '', '2026-05-16 11:44:09.915+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_88f41f16_f715_4575_9f95_dd0685dfd8eb, v_manager_id, 1850, 'cash', '', '2026-06-10 15:58:59.613+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f907fe28_822b_4ae6_b536_ca40d46f5eb3, v_manager_id, 1850, 'cash', '', '2026-06-17 13:42:16.838+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0e9eb187_a964_4ff0_b11b_763b66f5310a, v_manager_id, 3700, 'cash', '', '2026-04-18 14:21:12.152792+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a37e94b7_4cce_432f_b938_782fe963a7eb, v_manager_id, 4200, 'cash', '', '2026-06-17 10:31:09.963472+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f48a91fd_23bd_4163_8062_710857a88633, v_manager_id, 1850, 'cash', '', '2026-05-21 09:45:01.347015+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5c5d5520_c83e_4249_8022_58094bf80794, v_manager_id, 3500, 'cash', '', '2026-02-13 07:37:45.094+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7b83db63_5fbc_4d0e_9c4c_718a38a89ff8, v_manager_id, 2500, 'cash', '', '2026-06-11 14:25:08.444556+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_035a0b87_5e0a_4747_ab10_096701774729, v_manager_id, 1850, 'cash', '', '2026-02-09 06:46:53.589974+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8d7a8a39_3bbf_46f0_8db8_6399b0419819, v_manager_id, 3000, 'cash', '', '2026-04-18 11:46:32.956962+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ee15ed87_711d_45bf_af52_76c54f841d9a, v_manager_id, 2000, 'cash', '', '2026-02-05 08:55:17.085947+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_92ecfbdb_2247_4938_8a3e_c55e724e13b9, v_manager_id, 4100, 'cash', '', '2026-01-31 14:51:08.734+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_52161fcb_317a_41e1_9f97_70261385b36c, v_manager_id, 1500, 'cash', '', '2026-02-16 10:38:23.608+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0ababa08_aa34_4744_b19a_853ffaa48a3a, v_manager_id, 2500, 'cash', '', '2026-06-17 13:00:53.66713+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_62434a1b_0461_461b_a378_53c38af5ba05, v_manager_id, 1850, 'cash', '', '2026-02-11 08:30:53.32357+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_229ce27a_279c_45e7_acce_e657728c7771, v_manager_id, 2000, 'cash', '', '2026-03-31 09:42:28.441934+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_376209e8_9c96_41be_a0bc_28dd883cc40a, v_manager_id, 500, 'cash', '', '2026-06-29 10:54:34.301+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e99e4999_929b_48c2_820f_337864586030, v_manager_id, 7200, 'cash', '', '2026-04-03 08:08:45.355691+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c9867a7f_463c_4172_b188_e7c396d5f791, v_manager_id, 2000, 'cash', '', '2026-05-02 13:44:16.774161+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_05cd7b36_cbee_4fa3_aed9_bfbc42d61c6e, v_manager_id, 2000, 'cash', '', '2026-06-30 15:17:56.545562+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_55e127ad_33e3_4e8b_a119_f3a0db1c5fd4, v_manager_id, 1850, 'cash', '', '2026-05-09 09:50:33.096173+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_211ddf87_cbc7_4b08_a9f8_5c016a1ac3df, v_manager_id, 4500, 'cash', '', '2026-04-06 09:51:10.647215+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fb79ebce_ed8a_41a8_ada9_e12d3076f320, v_manager_id, 4600, 'cash', '', '2026-04-16 09:37:29.742+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_48c2ed03_5414_4c24_9857_a8ed17c044df, v_manager_id, 3500, 'cash', '', '2026-05-14 15:21:52.115051+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9be5eead_6777_4870_b0bf_6ed9a569d97f, v_manager_id, 3400, 'cash', '', '2026-05-22 12:22:29.737+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_105b4470_aad5_4220_a3bb_2913fcff7fb5, v_manager_id, 1600, 'cash', '', '2026-06-19 12:36:55.621608+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bc73605a_df11_49ee_bc70_b23c8a193f00, v_manager_id, 1850, 'cash', '', '2026-04-14 15:52:01.21885+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_437b69fd_69ed_4ddb_ad56_4e22e0ee49a4, v_manager_id, 500, 'cash', '', '2026-05-23 14:30:25.229+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3fef6309_97f9_4786_ab66_734ce3fd7d7e, v_manager_id, 1800, 'cash', '', '2026-05-04 09:40:51.739716+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_625dca75_715a_42dc_a5d1_8633048ec197, v_manager_id, 4000, 'cash', '', '2026-03-05 14:40:28.368324+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8f6f90d1_71e3_41d1_94cf_8380f293a753, v_manager_id, 1500, 'cash', '', '2026-04-11 09:32:32.259481+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_04ac11e0_f980_430f_b891_ef0c764c4c6e, v_manager_id, 1700, 'cash', '', '2026-04-09 13:13:22.606+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b106bf8a_f444_497e_9a28_e51c0584de02, v_manager_id, 1850, 'cash', '', '2026-02-16 16:21:58.865+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e6cd6425_1b1e_48ad_9ce1_f011b42700b8, v_manager_id, 1850, 'cash', '', '2026-05-30 10:31:46.467+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fbfffea4_6630_4551_bde1_39d21774d2cb, v_manager_id, 7450, 'cash', '', '2026-06-09 12:15:04.114035+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_73c4746c_db36_44c2_89b1_fef3ed896943, v_manager_id, 1700, 'cash', '', '2026-04-16 14:19:18.989+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_19781198_57d6_42d0_ac22_3c7ab36b0172, v_manager_id, 1700, 'cash', '', '2026-06-16 12:22:12.61512+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_37a9d214_5b59_4dc3_8002_cc842a7d59da, v_manager_id, 1850, 'cash', '', '2026-04-02 06:41:32.135+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_60013079_a55d_4155_8e3b_af2da332ced8, v_manager_id, 1500, 'cash', '', '2026-04-08 07:02:03.625612+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_dca13654_fd66_45be_bbef_6831d6f3839e, v_manager_id, 5450, 'cash', '', '2026-05-07 11:21:30.246164+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_34ede3e6_03ad_4998_a845_4e956d4049ac, v_manager_id, 1750, 'cash', '', '2026-03-12 15:20:42.033+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9122c1d8_94ef_4e6d_af48_41aa9298a366, v_manager_id, 1850, 'cash', '', '2026-05-10 04:55:23.989+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_1198ce1c_36b8_4230_9a2b_633ff3a34485, v_manager_id, 4000, 'cash', '', '2026-03-27 14:12:27.075+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5412c8fb_9740_4aaf_95d2_b6c3ec621a07, v_manager_id, 3700, 'cash', '', '2026-02-02 14:11:11.073058+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ebf91396_e436_46e9_a28d_3b0a7eaa6811, v_manager_id, 1850, 'cash', '', '2026-06-13 04:37:15.512+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8e4e60a5_2027_4a84_9271_635b2347da03, v_manager_id, 3500, 'cash', '', '2026-06-13 12:41:49.027477+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a47bd80b_1ae8_4572_986c_8b39290b45c4, v_manager_id, 2000, 'cash', '', '2026-06-11 11:39:16.757665+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c0492aab_e819_4d8a_92fa_363554f590e0, v_manager_id, 3700, 'cash', '', '2026-02-19 12:08:44.377771+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_78cdf8e7_2542_4cfa_b99a_0fb574a5bf10, v_manager_id, 3700, 'cash', '', '2026-02-17 12:13:18.831063+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_66b0ea02_73db_43f3_9566_6304c75c95e6, v_manager_id, 3900, 'cash', '', '2026-04-13 14:14:27.002021+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_781de23c_a86c_48d1_bba6_71fe51a72ed6, v_manager_id, 1850, 'cash', '', '2026-05-07 12:57:48.180478+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d617c6f0_1cbc_4ab4_afa5_db3e1cf24c62, v_manager_id, 14900, 'cash', '', '2026-02-04 14:33:42.466044+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d7f2515f_2fc7_4690_8f46_d18a13f0b2eb, v_manager_id, 1850, 'cash', '', '2026-02-18 12:06:43.13548+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fd94950c_fd6b_4be5_a231_bc2371db2946, v_manager_id, 3250, 'cash', '', '2026-03-26 10:25:29.416+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2bad0435_1614_44f1_a73b_85b99e47d913, v_manager_id, 1850, 'cash', '', '2026-02-17 09:11:59.876834+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e0e25228_4dde_4f65_90b1_6692cb82b8d6, v_manager_id, 2450, 'cash', '', '2026-06-29 11:35:50.487056+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_353a301d_6989_451a_865f_a075708768ce, v_manager_id, 2350, 'cash', '', '2026-03-21 10:09:04.323593+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b07eea9b_b3ac_48fa_93a0_e4671ca500b5, v_manager_id, 3000, 'cash', '', '2026-04-01 15:21:41.89+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d934c8a7_42ca_472d_b70b_70631e7bce0f, v_manager_id, 2750, 'cash', '', '2026-01-27 13:22:51.674444+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_77e81e1a_1aff_4da0_9137_2c3562b244bc, v_manager_id, 3250, 'cash', '', '2026-03-21 11:11:11.975+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_71c540ea_44f7_4e7a_ab20_a2d025ab3182, v_manager_id, 1600, 'cash', '', '2026-04-24 14:30:26.245+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_625dca75_715a_42dc_a5d1_8633048ec197, v_manager_id, 3200, 'cash', '', '2026-03-16 12:51:17.737+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ab0d4683_d837_495a_8c13_bd9c6f09855e, v_manager_id, 3700, 'cash', '', '2026-06-12 18:22:24.365177+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5412c8fb_9740_4aaf_95d2_b6c3ec621a07, v_manager_id, 3700, 'cash', '', '2026-02-05 08:56:13.131+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6c3e54a1_1270_4ad5_9839_ab5ab310b98d, v_manager_id, 4500, 'cash', '', '2026-04-13 14:13:11.502006+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0e3b02c2_94fa_47fd_aa09_2d2f3d52336e, v_manager_id, 3000, 'cash', '', '2026-04-11 12:15:16.912074+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8f6f90d1_71e3_41d1_94cf_8380f293a753, v_manager_id, 2700, 'cash', '', '2026-04-18 08:41:51.029+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d389befa_eb54_4248_9683_d9bbc109fcfb, v_manager_id, 3000, 'cash', '', '2026-03-21 11:19:04.412269+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_660eea38_841a_4654_a857_49b6739eb674, v_manager_id, 3700, 'cash', '', '2026-06-18 09:59:29.663+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_105b4470_aad5_4220_a3bb_2913fcff7fb5, v_manager_id, 2100, 'cash', '', '2026-06-22 08:34:52.197+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4fbe841d_1e68_40e8_9a81_8701dbcbaecb, v_manager_id, 3500, 'cash', '', '2026-01-10 14:28:49.145586+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5cd9aea2_4ce0_4681_a00d_10b4e6820a98, v_manager_id, 3000, 'cash', '', '2026-02-20 10:54:45.515+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_911d4d60_e960_4dcd_9438_2fd16672fe2d, v_manager_id, 3500, 'cash', '', '2026-03-21 14:56:46.869338+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_991ded7f_c47d_457b_977a_75f06f924164, v_manager_id, 2100, 'cash', '', '2026-03-21 13:24:25.592131+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_471f49e8_14d8_411a_a83f_0e403595b815, v_manager_id, 1750, 'cash', '', '2026-06-27 07:40:00.785191+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c4100220_789a_4861_bb1a_d7d7ddca83cc, v_manager_id, 2350, 'cash', '', '2026-01-23 11:27:25.868+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_46858bdb_80ad_45d0_8a7d_f2423052b76e, v_manager_id, 6000, 'cash', '', '2026-03-06 15:50:43.727372+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_db465ae5_b8f1_4245_9a02_34f41e61153a, v_manager_id, 2250, 'cash', '', '2026-04-16 15:28:54.602174+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_22186ffa_a0c1_42f7_8551_031ef5e36a51, v_manager_id, 2400, 'cash', '', '2026-06-03 14:04:34.60346+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_32971693_a74c_4d48_a189_fd079dba1aa6, v_manager_id, 7750, 'cash', '', '2026-01-31 14:43:56.132461+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_46858bdb_80ad_45d0_8a7d_f2423052b76e, v_manager_id, 6200, 'cash', '', '2026-05-07 15:41:53.181+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_709dec22_5a7c_43d4_b477_0633488b1ecc, v_manager_id, 6500, 'cash', '', '2026-02-26 11:34:56.869331+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_78868fc0_7111_4df4_aaa8_98e98c830f29, v_manager_id, 1850, 'cash', '', '2026-03-27 15:08:19.112+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6183e2ec_e0bd_4b32_995e_a60d46116da6, v_manager_id, 1850, 'cash', '', '2026-04-04 09:16:57.571+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_858aa9c0_3417_44c5_8ced_1228e1add8aa, v_manager_id, 5500, 'cash', '', '2026-02-17 11:07:00.572074+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5b114319_7218_415b_9f72_7aeeb66b64fd, v_manager_id, 3900, 'cash', '', '2026-06-20 10:32:49.656+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_375a3d1b_b606_4907_bae7_1924e2493034, v_manager_id, 3700, 'cash', '', '2026-06-24 10:36:37.928125+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_13095957_37e4_4868_b240_4041465dbe55, v_manager_id, 1980, 'cash', '', '2026-06-06 14:08:46.687057+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5cd9aea2_4ce0_4681_a00d_10b4e6820a98, v_manager_id, 3000, 'cash', '', '2026-02-09 15:00:20.505879+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_edf1a27c_72c2_4ad8_b066_7233353f567f, v_manager_id, 3700, 'cash', '', '2026-02-23 10:28:58.464912+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_adfd2172_08cc_4db6_a736_abac7938d514, v_manager_id, 2100, 'cash', '', '2026-06-04 10:45:02.566+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_dca13654_fd66_45be_bbef_6831d6f3839e, v_manager_id, 5450, 'cash', '', '2026-05-14 13:15:50.891+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_36964c97_250e_4d1c_867b_072f52b1ef1a, v_manager_id, 4700, 'cash', '', '2026-03-27 13:40:50.994851+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c7b05f3f_351b_4020_85d3_c3599362d243, v_manager_id, 1850, 'cash', '', '2026-02-13 13:32:37.985+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e9cca742_cd11_4f21_b8ef_275ead8cee6f, v_manager_id, 1700, 'cash', '', '2026-02-06 11:50:56.008+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_72f9a4b6_3777_411e_8309_27b7f3a4f996, v_manager_id, 7500, 'cash', '', '2026-01-07 07:20:27.234494+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f8f41fc4_5cd1_4cfb_b8b1_511377e97c26, v_manager_id, 3500, 'cash', '', '2026-02-25 13:47:59.49436+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0d103666_3eaa_43c1_9dac_2c7a3e038426, v_manager_id, 1850, 'cash', '', '2026-02-23 13:09:33.233599+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_33b19d16_8b05_494e_9787_66b53b65930e, v_manager_id, 1700, 'cash', '', '2026-03-21 04:57:11.024+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6b1cafef_9ca9_46d4_bbab_df852c9936e4, v_manager_id, 2000, 'cash', '', '2026-04-10 10:47:25.601+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4391054d_3169_49ab_b62b_7f75f3f534aa, v_manager_id, 1850, 'cash', '', '2026-05-23 09:49:37.207097+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b9d668b9_9762_48a0_9024_78113c559347, v_manager_id, 1850, 'cash', '', '2026-04-21 13:30:35.924+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2567af9f_3253_4ab1_80c7_cffe58c6653f, v_manager_id, 2100, 'cash', '', '2026-02-18 10:08:03.832941+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7f6b6bbc_2106_49d4_9514_326c22273f8c, v_manager_id, 3500, 'cash', '', '2026-01-31 14:50:10.255+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_41ad28d3_28e0_4d62_832e_d8fffdb4a847, v_manager_id, 1750, 'cash', '', '2026-06-18 12:54:39.612062+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_1194f579_8390_42a9_baf1_a9556923eb70, v_manager_id, 4200, 'cash', '', '2026-05-21 16:16:27.727387+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5b114319_7218_415b_9f72_7aeeb66b64fd, v_manager_id, 4500, 'cash', '', '2026-06-15 16:07:25.311282+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_dd330e70_7144_44c8_b541_b670477163d0, v_manager_id, 3500, 'cash', '', '2026-02-17 13:26:19.229991+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_429ea2fa_65a0_4e0c_a828_f64d9e02acd5, v_manager_id, 1800, 'cash', '', '2026-03-12 09:35:57.729+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b7b011f3_f616_48ba_8bd4_7f1c0984517f, v_manager_id, 1850, 'cash', '', '2026-06-29 14:33:02.840047+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_92f372aa_48ad_4fed_944c_055b78d476cf, v_manager_id, 1850, 'cash', '', '2026-06-29 11:13:52.627768+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ef27d9a5_c1aa_477e_bcd2_4640e2dfe229, v_manager_id, 4700, 'cash', '', '2026-05-27 13:12:10.148871+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_31c73b06_7406_42a1_b392_413fce055657, v_manager_id, 4200, 'cash', '', '2026-03-12 14:05:29.239064+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7c5d3448_fa66_4a5c_bf36_1e6bb02f6816, v_manager_id, 7700, 'cash', '', '2026-05-19 10:25:23.801035+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d38bbc6e_cc01_4c79_8f44_f1febbd767dd, v_manager_id, 2200, 'cash', '', '2026-06-26 07:03:43.662+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_079030b9_cd99_434b_8980_c536f1fbff82, v_manager_id, 8775, 'cash', '', '2026-06-13 04:35:56.446+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c02ea85e_e8e1_40a4_b2ab_f8850044d54c, v_manager_id, 2000, 'cash', '', '2026-06-01 09:14:38.003753+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_26560755_83c8_4d76_a7e1_c07f7f97e3b9, v_manager_id, 1850, 'cash', '', '2026-05-22 15:33:39.925+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d2cd0697_9374_41de_b487_b926fa687c63, v_manager_id, 2000, 'cash', '', '2026-06-22 10:58:45.56059+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_dfcc12ab_1920_41a9_89df_7cfa22d9af44, v_manager_id, 1850, 'cash', '', '2026-06-18 12:50:15.575+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fec347e8_9ce4_4bca_8e79_e7ee0fcbbb12, v_manager_id, 1500, 'cash', '', '2026-06-24 07:07:48.952+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a37e94b7_4cce_432f_b938_782fe963a7eb, v_manager_id, 4200, 'cash', '', '2026-06-23 09:27:25.12+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_af476951_900f_4d9c_822f_d94015053f71, v_manager_id, 2000, 'cash', '', '2026-06-16 10:10:06.321+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9da98588_ec9b_4022_9126_eb706555892b, v_manager_id, 1850, 'cash', '', '2026-02-04 14:19:45.993259+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a1f6cc5a_b6ff_4bc4_9a2a_7c4a0cf14dd0, v_manager_id, 500, 'cash', '', '2026-02-13 06:25:39.169+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f26883c1_d830_4871_ab5b_d1b5a8fff409, v_manager_id, 2100, 'cash', '', '2026-06-04 11:09:54.586+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3cbc6279_7bfb_42fa_b8d5_5d44346f11d6, v_manager_id, 2250, 'cash', '', '2026-02-24 18:51:09.329849+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8261b4d3_9c5a_4a02_ac60_55338eebbe92, v_manager_id, 1900, 'cash', '', '2026-06-19 12:40:51.477+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_52901161_b017_4eea_aef9_618f84b7e545, v_manager_id, 1750, 'cash', '', '2026-04-21 10:13:08.856332+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a97db74f_f2ed_46cc_aae9_7b4661cd79cb, v_manager_id, 3750, 'cash', '', '2026-03-18 05:31:25.918+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_17f1a5f1_0f0b_4629_82a7_4926ce3440af, v_manager_id, 7250, 'cash', '', '2026-03-12 13:17:13.733035+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_13095957_37e4_4868_b240_4041465dbe55, v_manager_id, 1970, 'cash', '', '2026-06-11 14:38:37.382+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_78844f7c_db9e_403d_9167_727a35e4e7c9, v_manager_id, 1850, 'cash', '', '2026-02-13 11:41:05.893008+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a4f09ca1_5b41_419f_ab29_c74d830d0cc9, v_manager_id, 4000, 'cash', '', '2026-03-11 07:14:24.706+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e7a07563_ffb1_4f9e_8fe8_18b6ee4a5d2d, v_manager_id, 5500, 'cash', '', '2026-03-27 13:49:03.81+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3f4313e9_07b6_4c8f_be4b_f49cba1b2872, v_manager_id, 3500, 'cash', '', '2026-02-02 03:43:05.925494+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a47bd80b_1ae8_4572_986c_8b39290b45c4, v_manager_id, 1700, 'cash', '', '2026-06-22 11:07:12.105+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_61860dd4_8965_4fef_aeb3_2a63dbb15d03, v_manager_id, 1700, 'cash', '', '2026-06-04 16:31:47.676982+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_71c540ea_44f7_4e7a_ab20_a2d025ab3182, v_manager_id, 2600, 'cash', '', '2026-04-21 13:43:40.740666+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0ababa08_aa34_4744_b19a_853ffaa48a3a, v_manager_id, 1500, 'cash', '', '2026-06-22 10:28:32.796+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d7b2547d_4563_4ec0_b43d_c9b2ce46aa38, v_manager_id, 3700, 'cash', '', '2026-03-13 14:52:50.463034+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_97daf4f4_7475_46c4_a3eb_a1c13706b4ef, v_manager_id, 2100, 'cash', '', '2026-05-26 12:29:32.159068+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7824a73a_3de9_4719_a37e_3e4b8c370cb5, v_manager_id, 3700, 'cash', '', '2026-04-21 10:28:15.212006+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8544e6c6_ba3f_4da3_94a0_9e0dc55eae34, v_manager_id, 1200, 'cash', '', '2026-03-26 13:23:40.734+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4fe15d4e_ee02_45b3_9801_9af35c27570e, v_manager_id, 5250, 'cash', '', '2026-01-17 11:51:23.444257+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ea388d6b_8cbe_4839_bcf6_e61a54b366e7, v_manager_id, 1700, 'cash', '', '2026-02-03 11:23:51.777+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0607675f_fb89_4c83_b7c7_919d9e426eee, v_manager_id, 3700, 'cash', '', '2026-05-09 14:45:31.322308+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c145b544_232b_4c08_926f_e054a68647df, v_manager_id, 1500, 'cash', '', '2026-06-29 12:38:33.326+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6ed7640a_c3a0_432b_856a_ca63feddcc67, v_manager_id, 2500, 'cash', '', '2026-02-19 12:42:29.161155+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_1198ce1c_36b8_4230_9a2b_633ff3a34485, v_manager_id, 4000, 'cash', '', '2026-03-21 13:27:50.329659+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_aeb95683_91f5_49e2_adf9_f4314ff556dc, v_manager_id, 2000, 'cash', '', '2026-06-17 16:14:44.124794+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_55aacc69_68c7_48d8_a662_f25b0b03ce49, v_manager_id, 4500, 'cash', '', '2026-01-17 10:16:04.264241+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_858aa9c0_3417_44c5_8ced_1228e1add8aa, v_manager_id, 5500, 'cash', '', '2026-02-20 15:19:09.036+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f1d260d7_73dd_4332_baa6_7d2fcda635ea, v_manager_id, 9000, 'cash', '', '2026-06-23 10:42:52.61732+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a4f09ca1_5b41_419f_ab29_c74d830d0cc9, v_manager_id, 3500, 'cash', '', '2026-03-05 07:28:17.515102+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e4319103_6484_4571_a1ec_d714d2cfb084, v_manager_id, 1850, 'cash', '', '2026-05-08 13:36:02.701+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fa02ecff_3be5_4f97_875b_3d4cb1c1b818, v_manager_id, 1850, 'cash', '', '2026-05-14 12:59:03.604+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d2a6c846_4ad7_4b9a_9a5a_3fc8f56fed1a, v_manager_id, 2500, 'cash', '', '2026-02-24 12:23:49.469809+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_23a7aa01_71bf_4ac6_8ad0_885138422b5b, v_manager_id, 5000, 'cash', '', '2026-03-06 08:50:16.768449+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5b15bc02_0ac0_435d_9843_0a93b1faa926, v_manager_id, 3020, 'cash', '', '2026-04-24 14:29:54.791+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_425f4714_ca96_417d_af0f_c98af89abf59, v_manager_id, 2000, 'cash', '', '2026-03-05 15:49:09.908+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_61e1dc0e_95b1_4631_bfe0_140cb723735d, v_manager_id, 1700, 'cash', '', '2026-06-26 15:58:08.445+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_1390ef8a_e13b_40bb_89a7_c536cbbf323c, v_manager_id, 2000, 'cash', '', '2026-02-20 08:57:34.574472+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d2f81793_c3a4_475d_8c08_331bb0036ebd, v_manager_id, 8000, 'cash', '', '2026-02-25 16:00:43.378524+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3bc9e832_f5a4_401d_8fa5_f3b60019ec13, v_manager_id, 3500, 'cash', '', '2026-06-17 16:19:52.990166+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_30f41e72_1c85_459a_b005_1767dfd1203e, v_manager_id, 2000, 'cash', '', '2026-06-19 16:00:19.171+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_97d156f9_3973_4190_95c2_3e3ef95f9d2c, v_manager_id, 3700, 'cash', '', '2026-06-30 14:44:10.448053+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c145b544_232b_4c08_926f_e054a68647df, v_manager_id, 2000, 'cash', '', '2026-06-23 11:57:29.557005+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8d3f6d93_8b43_45cb_8ee2_261fcda8d7a6, v_manager_id, 1200, 'cash', '', '2026-06-16 11:10:37.807+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0c8af382_4867_46ea_a8fb_c83038b4d021, v_manager_id, 4200, 'cash', '', '2026-03-18 16:17:21.306371+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3b7785cf_2fed_4b3c_8c6b_def1f3acc699, v_manager_id, 4000, 'cash', '', '2026-06-13 09:34:04.994355+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a3cc2eed_d392_4e5f_be80_43951e812cba, v_manager_id, 4700, 'cash', '', '2026-06-17 10:10:24.914271+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_286f7ca0_c98b_4946_9ac3_9b29b57f41bf, v_manager_id, 1850, 'cash', '', '2026-06-30 08:40:06.958+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_cc1ff338_f6bd_4a87_8d94_1e131a7ca25e, v_manager_id, 5000, 'cash', '', '2026-05-05 15:51:56.284402+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5697b913_2fb0_4559_ba97_430a7c7f56ca, v_manager_id, 1950, 'cash', '', '2026-02-03 09:26:16.67+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_41b0f602_b136_4702_a000_f96a51a77693, v_manager_id, 2750, 'cash', '', '2026-01-27 14:21:33.763+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d7f2515f_2fc7_4690_8f46_d18a13f0b2eb, v_manager_id, 1850, 'cash', '', '2026-02-26 08:54:41.568+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8a5e9bf5_9f1f_4230_93bd_1ce79c06f092, v_manager_id, 5000, 'cash', '', '2026-05-19 04:23:47.896511+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b6bb2e2b_a9e6_4cef_87f2_318839f642d3, v_manager_id, 2100, 'cash', '', '2026-04-22 09:35:23.701854+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_34ede3e6_03ad_4998_a845_4e956d4049ac, v_manager_id, 1750, 'cash', '', '2026-03-06 11:17:03.690457+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4fe15d4e_ee02_45b3_9801_9af35c27570e, v_manager_id, 5250, 'cash', '', '2026-01-21 10:15:28.102+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a9368b86_daef_418c_985b_14b8ef8be401, v_manager_id, 1950, 'cash', '', '2026-03-21 10:36:07.516+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2b490617_11c3_4aa7_857f_ec9437354b60, v_manager_id, 4000, 'cash', '', '2026-02-18 15:53:58.943515+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_660eea38_841a_4654_a857_49b6739eb674, v_manager_id, 3500, 'cash', '', '2026-06-11 12:16:27.812553+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6d7e80df_88e8_4f9f_a575_eb73b16b188e, v_manager_id, 2250, 'cash', '', '2026-06-26 08:17:22.955+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d2cd0697_9374_41de_b487_b926fa687c63, v_manager_id, 1500, 'cash', '', '2026-06-24 13:57:29.482+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f1edefcd_ebb4_4b49_a346_10b6814f0689, v_manager_id, 3700, 'cash', '', '2026-02-20 15:49:40.352327+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_aa319382_afe7_4500_afa3_53c1072264cd, v_manager_id, 3500, 'cash', '', '2026-02-17 13:28:52.113898+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5c5d5520_c83e_4249_8022_58094bf80794, v_manager_id, 3500, 'cash', '', '2026-02-09 07:01:27.535247+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_af476951_900f_4d9c_822f_d94015053f71, v_manager_id, 2000, 'cash', '', '2026-06-11 11:27:55.95017+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a805c5d3_c331_4165_b3e4_6f8a013e1622, v_manager_id, 3700, 'cash', '', '2026-04-18 10:47:07.645613+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_02801f54_cdac_4bec_b732_13a41ae6ccca, v_manager_id, 2500, 'cash', '', '2026-02-03 14:28:22.464+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fa3b636b_038a_42c8_90fe_8e229e8ec0ae, v_manager_id, 1750, 'cash', '', '2026-06-16 13:19:31.375988+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_82f59488_fd69_4905_ba60_5d33795556d0, v_manager_id, 2250, 'cash', '', '2026-03-03 11:05:18.361281+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_be6f8d55_c5d7_44f9_b0fe_5201a3b3bbf0, v_manager_id, 3700, 'cash', '', '2026-05-09 04:57:40.016243+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6b15494f_fdeb_4e2c_83b2_e116ce746359, v_manager_id, 3700, 'cash', '', '2026-03-14 12:41:44.24888+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fa720a5c_efca_48f8_a1e8_ede9c79c52b0, v_manager_id, 2100, 'cash', '', '2026-06-20 12:17:39.0484+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_429ea2fa_65a0_4e0c_a828_f64d9e02acd5, v_manager_id, 1900, 'cash', '', '2026-03-10 19:26:34.157889+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_77e81e1a_1aff_4da0_9137_2c3562b244bc, v_manager_id, 5750, 'cash', '', '2026-02-25 07:48:19.780387+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b7705875_6b63_4e62_9151_f1ceef5b92e7, v_manager_id, 1700, 'cash', '', '2026-02-26 07:58:48.235+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0d103666_3eaa_43c1_9dac_2c7a3e038426, v_manager_id, 1850, 'cash', '', '2026-02-26 11:42:04.68+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_376209e8_9c96_41be_a0bc_28dd883cc40a, v_manager_id, 3000, 'cash', '', '2026-06-26 14:05:29.035148+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a4f38966_f52e_4828_9fad_27ba98864fc5, v_manager_id, 30000, 'cash', '', '2026-04-16 08:07:28.403406+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2a87202c_0ed1_4da5_a8d1_b62219ac9a52, v_manager_id, 4200, 'cash', '', '2026-02-11 07:10:37.284214+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3e396821_be2d_43f7_8a71_677ce1a442f9, v_manager_id, 3950, 'cash', '', '2026-04-09 12:55:00.858+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_1f113fa4_caad_4027_b97e_e0538dd372e9, v_manager_id, 1300, 'cash', '', '2026-03-06 08:33:50.914+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9ddf5337_f404_4499_8297_9f4e22346934, v_manager_id, 3500, 'cash', '', '2026-05-13 16:53:42.686054+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9886f983_4d56_4046_9382_cd8faa01bf5c, v_manager_id, 3500, 'cash', '', '2026-06-27 13:22:44.934392+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_72f9a4b6_3777_411e_8309_27b7f3a4f996, v_manager_id, 7500, 'cash', '', '2026-01-23 13:39:53.769+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d4079abd_86f7_4b24_85ff_b71e5b4ed5ad, v_manager_id, 3500, 'cash', '', '2026-01-30 12:18:08.036+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5add4268_e2cd_4f2c_9f9a_57d673d222bf, v_manager_id, 4900, 'cash', '', '2026-06-24 11:49:04.427439+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_af0ee547_3c32_4039_bbf7_2c892f312963, v_manager_id, 3700, 'cash', '', '2026-06-16 13:45:13.537394+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e4319103_6484_4571_a1ec_d714d2cfb084, v_manager_id, 1850, 'cash', '', '2026-05-04 12:59:58.96844+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2bad0435_1614_44f1_a73b_85b99e47d913, v_manager_id, 1850, 'cash', '', '2026-02-19 09:20:05.081+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d9d70c11_c607_4bcd_ab38_c0159d56b14a, v_manager_id, 3700, 'cash', '', '2026-02-14 11:35:28.162398+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8950f0ae_c2f1_4030_a24a_504aae3a7fb5, v_manager_id, 2250, 'cash', '', '2026-04-09 11:04:28.105+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fd3b5d5a_3e28_43a3_bbc1_e801909abce6, v_manager_id, 3500, 'cash', '', '2026-01-05 15:41:20.125229+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_612281e1_040d_409c_9a73_75e55a831601, v_manager_id, 2100, 'cash', '', '2026-02-04 12:11:47.675308+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e9cca742_cd11_4f21_b8ef_275ead8cee6f, v_manager_id, 2000, 'cash', '', '2026-02-02 06:32:34.396411+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3448b53b_7832_4136_903d_554c40f9267d, v_manager_id, 1850, 'cash', '', '2026-04-17 14:58:45.515+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_82df5a29_2b2b_4d88_b3ff_c51eb6bd4f9f, v_manager_id, 2350, 'cash', '', '2026-06-09 10:06:37.09+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d8a7d739_4d2b_4de5_9bd7_2af5132502bf, v_manager_id, 3500, 'cash', '', '2026-06-17 08:31:08.342559+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a6a22c6b_6bec_44a9_b342_1abf4094591a, v_manager_id, 3700, 'cash', '', '2026-01-12 16:45:03.781+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5454e22a_821a_44e9_afa4_07828b06a00b, v_manager_id, 1850, 'cash', '', '2026-02-11 15:25:27.215189+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fd94950c_fd6b_4be5_a231_bc2371db2946, v_manager_id, 3250, 'cash', '', '2026-03-23 11:49:26.859932+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_52901161_b017_4eea_aef9_618f84b7e545, v_manager_id, 1750, 'cash', '', '2026-04-23 14:47:10.349+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0b627b54_94b8_4a99_ade6_339762265279, v_manager_id, 1850, 'cash', '', '2026-03-05 15:03:34.424+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0b627b54_94b8_4a99_ade6_339762265279, v_manager_id, 1850, 'cash', '', '2026-02-26 15:02:57.841954+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d2a6c846_4ad7_4b9a_9a5a_3fc8f56fed1a, v_manager_id, 2000, 'cash', '', '2026-02-27 12:21:48.376+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6b1cafef_9ca9_46d4_bbab_df852c9936e4, v_manager_id, 1950, 'cash', '', '2026-04-08 04:38:36.27393+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b07eea9b_b3ac_48fa_93a0_e4671ca500b5, v_manager_id, 2500, 'cash', '', '2026-03-28 17:44:51.596978+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b106bf8a_f444_497e_9a28_e51c0584de02, v_manager_id, 1850, 'cash', '', '2026-02-09 10:42:38.97186+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_1390ef8a_e13b_40bb_89a7_c536cbbf323c, v_manager_id, 1950, 'cash', '', '2026-02-24 14:02:54.421+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8521ee7e_4b34_4ff3_a4d9_f5f8fd3a874d, v_manager_id, 1850, 'cash', '', '2026-06-24 13:08:19.077+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e33ced74_93d4_4fa4_9a0c_0e95a0412669, v_manager_id, 9000, 'cash', '', '2026-04-12 16:04:41.823+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c7b05f3f_351b_4020_85d3_c3599362d243, v_manager_id, 1850, 'cash', '', '2026-02-09 18:27:51.535673+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_82f59488_fd69_4905_ba60_5d33795556d0, v_manager_id, 2250, 'cash', '', '2026-03-28 12:12:01.384+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_08091250_d494_443e_b419_a28e349bdef4, v_manager_id, 2000, 'cash', '', '2026-05-27 10:36:22.277934+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_56c5cca7_5e8e_4216_bc03_a50bbc6178d9, v_manager_id, 4500, 'cash', '', '2026-02-27 11:54:10.293+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_25c9d6c3_f731_4764_8970_126f278cf204, v_manager_id, 3700, 'cash', '', '2026-04-28 14:11:18.63097+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_07f19229_c185_4a64_a8f1_6fdd69245e36, v_manager_id, 4500, 'cash', '', '2026-03-21 09:56:01.549653+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_60013079_a55d_4155_8e3b_af2da332ced8, v_manager_id, 2200, 'cash', '', '2026-04-10 11:08:07.121+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f764f45a_6193_4d16_ac5c_2d3a345c37e4, v_manager_id, 2000, 'cash', '', '2026-06-05 16:23:16.724188+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5983e0fc_5714_44d8_b90d_8e3b530e212b, v_manager_id, 2500, 'cash', '', '2026-06-22 12:04:35.436502+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_612281e1_040d_409c_9a73_75e55a831601, v_manager_id, 2100, 'cash', '', '2026-02-11 06:57:48.656+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9f1a3225_c288_46dd_bea8_fc03f9ded09f, v_manager_id, 3750, 'cash', '', '2026-06-22 14:07:03.631916+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0f09c1a7_4295_4a4b_94bc_70fbdb5b0807, v_manager_id, 4500, 'cash', '', '2026-05-26 12:51:00.452103+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_aeb95683_91f5_49e2_adf9_f4314ff556dc, v_manager_id, 1500, 'cash', '', '2026-06-22 10:53:11.912+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d389befa_eb54_4248_9683_d9bbc109fcfb, v_manager_id, 1200, 'cash', '', '2026-04-03 14:35:30.328+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3cbc6279_7bfb_42fa_b8d5_5d44346f11d6, v_manager_id, 2250, 'cash', '', '2026-03-02 10:03:14.56+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_62434a1b_0461_461b_a378_53c38af5ba05, v_manager_id, 1850, 'cash', '', '2026-02-14 13:50:12.851+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e16beef0_f1c0_4f05_b4bd_01dc8506f561, v_manager_id, 4200, 'cash', '', '2026-06-24 14:37:26.115783+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_443fcf26_babc_4086_9c05_fcc004b9f926, v_manager_id, 4500, 'cash', '', '2026-06-24 11:39:12.586038+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7c584062_600d_426f_b6fb_dfe4f3019af6, v_manager_id, 2000, 'cash', '', '2026-02-28 06:25:16.699204+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_37a9d214_5b59_4dc3_8002_cc842a7d59da, v_manager_id, 1850, 'cash', '', '2026-03-30 08:56:45.976212+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_73c4746c_db36_44c2_89b1_fef3ed896943, v_manager_id, 2000, 'cash', '', '2026-04-13 06:58:37.625651+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2d2cde47_49a7_4c24_b4f7_a8091ff2c599, v_manager_id, 1850, 'cash', '', '2026-06-18 12:38:40.146+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_05f7acc6_8526_422c_88d8_bb7d94da23c6, v_manager_id, 1700, 'cash', '', '2026-03-27 13:41:47.58+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6bd1b009_afde_471b_9a0a_5e5e4dc5f72d, v_manager_id, 3700, 'cash', '', '2026-03-30 08:25:26.064777+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_00c6872a_7934_41ae_8ced_2e44bdf151db, v_manager_id, 3250, 'cash', '', '2026-02-11 07:43:24.877906+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_30f41e72_1c85_459a_b005_1767dfd1203e, v_manager_id, 2500, 'cash', '', '2026-06-15 17:45:35.524414+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a6a22c6b_6bec_44a9_b342_1abf4094591a, v_manager_id, 3500, 'cash', '', '2026-01-08 16:07:08.875753+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9be5eead_6777_4870_b0bf_6ed9a569d97f, v_manager_id, 4000, 'cash', '', '2026-05-20 14:12:03.326343+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_781de23c_a86c_48d1_bba6_71fe51a72ed6, v_manager_id, 1850, 'cash', '', '2026-06-09 13:53:43.171+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_52161fcb_317a_41e1_9f97_70261385b36c, v_manager_id, 2000, 'cash', '', '2026-02-10 10:40:43.68331+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c04c4f89_b82e_4145_a8ed_9fd36e808551, v_manager_id, 3700, 'cash', '', '2026-02-07 14:34:19.411666+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0076ad32_0554_44c2_a97e_d14d4bd1fa58, v_manager_id, 3700, 'cash', '', '2026-03-12 08:15:58.476159+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d617c6f0_1cbc_4ab4_afa5_db3e1cf24c62, v_manager_id, 4900, 'cash', '', '2026-02-11 11:44:39.134+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e31fbc9b_3149_4782_acf8_9c291497b650, v_manager_id, 2000, 'cash', '', '2026-06-16 15:12:19.661+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ea0ff900_5c06_4a3d_b41d_cd09463d8235, v_manager_id, 2500, 'cash', '', '2026-06-06 12:55:28.06+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f2ada1ba_4fd8_4f3d_bb20_c1a513f54c56, v_manager_id, 4700, 'cash', '', '2026-02-12 11:34:06.650483+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7c584062_600d_426f_b6fb_dfe4f3019af6, v_manager_id, 1700, 'cash', '', '2026-03-02 11:31:24.379+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b0c23acf_2622_4fde_81de_793d8e524a7d, v_manager_id, 1800, 'cash', '', '2026-05-27 10:26:08.279115+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_13243e03_5e09_4024_a21f_e8ed1233323b, v_manager_id, 7200, 'cash', '', '2026-03-26 15:02:23.782046+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_66378964_5e20_49cf_b146_f5001352ef45, v_manager_id, 2000, 'cash', '', '2026-06-24 14:08:56.016403+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bb1c9fe9_9aa1_4b6c_9a57_c54576ed3e14, v_manager_id, 1850, 'cash', '', '2026-03-30 12:49:56.163+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_035a0b87_5e0a_4747_ab10_096701774729, v_manager_id, 1850, 'cash', '', '2026-02-12 13:44:32.542+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_23a7aa01_71bf_4ac6_8ad0_885138422b5b, v_manager_id, 4500, 'cash', '', '2026-03-15 07:35:33.682+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5454e22a_821a_44e9_afa4_07828b06a00b, v_manager_id, 1850, 'cash', '', '2026-02-13 11:21:22.869+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9122c1d8_94ef_4e6d_af48_41aa9298a366, v_manager_id, 1850, 'cash', '', '2026-04-07 18:21:36.599855+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_05f7acc6_8526_422c_88d8_bb7d94da23c6, v_manager_id, 2000, 'cash', '', '2026-03-24 18:29:51.092302+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3f4990d9_d1bf_4f4d_865c_72c50d27bb10, v_manager_id, 1750, 'cash', '', '2026-06-15 13:19:51.458831+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8a5e9bf5_9f1f_4230_93bd_1ce79c06f092, v_manager_id, 4200, 'cash', '', '2026-05-27 09:42:32.083+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bdee4006_4124_4e6e_8217_dd20d8b98700, v_manager_id, 2300, 'cash', '', '2026-06-19 11:44:06.947+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_33b19d16_8b05_494e_9787_66b53b65930e, v_manager_id, 2000, 'cash', '', '2026-03-17 14:04:50.958152+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_db465ae5_b8f1_4245_9a02_34f41e61153a, v_manager_id, 2250, 'cash', '', '2026-04-25 09:55:39.116+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_dd74128e_2bec_4ed6_b749_2807c97cfe2b, v_manager_id, 11000, 'cash', '', '2026-06-13 14:33:16.260246+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ae1f8f0c_7d64_473c_afd4_a2d5f031cce2, v_manager_id, 4200, 'cash', '', '2026-05-13 09:03:08.302+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_da0b50a1_679d_4598_9598_0dfcc381f733, v_manager_id, 1975, 'cash', '', '2026-03-17 13:46:24.812+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6ea0e5ce_0ecb_49ef_9248_0ab6ba1e5f01, v_manager_id, 7100, 'cash', '', '2026-01-28 15:43:06.583652+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e7163579_254a_478e_bd48_5670febe6108, v_manager_id, 4500, 'cash', '', '2026-04-06 09:51:10.795606+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6ed7640a_c3a0_432b_856a_ca63feddcc67, v_manager_id, 2000, 'cash', '', '2026-02-26 15:29:36.549+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0e3b02c2_94fa_47fd_aa09_2d2f3d52336e, v_manager_id, 500, 'cash', '', '2026-04-16 10:55:28.479+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5dd8d2cd_ef81_4494_9caf_05555ba210c0, v_manager_id, 1700, 'cash', '', '2026-03-21 09:53:29.832+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b7705875_6b63_4e62_9151_f1ceef5b92e7, v_manager_id, 2000, 'cash', '', '2026-02-21 07:49:20.763665+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_55aacc69_68c7_48d8_a662_f25b0b03ce49, v_manager_id, 4500, 'cash', '', '2026-01-24 10:35:41.156+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_53dbdaee_db5d_41a2_b0f4_f0bcf3be1d83, v_manager_id, 1800, 'cash', '', '2026-02-19 14:56:50.883+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_88f41f16_f715_4575_9f95_dd0685dfd8eb, v_manager_id, 1850, 'cash', '', '2026-06-04 16:00:57.124786+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7c5d3448_fa66_4a5c_bf36_1e6bb02f6816, v_manager_id, 7700, 'cash', '', '2026-05-20 13:17:23.477+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6e9a3b25_b507_4ce7_a7b6_90033b854f47, v_manager_id, 1800, 'cash', '', '2026-05-04 17:36:55.765876+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e33ced74_93d4_4fa4_9a0c_0e95a0412669, v_manager_id, 5500, 'cash', '', '2026-03-26 12:38:27.815608+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3e396821_be2d_43f7_8a71_677ce1a442f9, v_manager_id, 3950, 'cash', '', '2026-04-07 05:55:59.614712+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9647382e_e309_432e_9bb4_d98c089da0ae, v_manager_id, 4000, 'cash', '', '2026-02-26 16:39:24.199151+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b9d668b9_9762_48a0_9024_78113c559347, v_manager_id, 1850, 'cash', '', '2026-04-07 06:02:57.737649+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fa3b636b_038a_42c8_90fe_8e229e8ec0ae, v_manager_id, 1750, 'cash', '', '2026-06-22 14:15:08.892+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ae1f8f0c_7d64_473c_afd4_a2d5f031cce2, v_manager_id, 4200, 'cash', '', '2026-05-01 11:53:28.803666+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_868c6bd5_126b_496f_9a24_705aae5adc14, v_manager_id, 4900, 'cash', '', '2026-06-23 12:56:01.55954+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_dba22eed_2047_40d1_80d2_b0a59d6597b8, v_manager_id, 2500, 'cash', '', '2026-06-07 16:02:05.73758+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_78868fc0_7111_4df4_aaa8_98e98c830f29, v_manager_id, 1850, 'cash', '', '2026-03-24 14:59:46.562306+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_37ba72c1_8280_4b59_9cd9_ba6c9e1eab28, v_manager_id, 1500, 'cash', '', '2026-06-04 10:10:24.775+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b19018d6_fe68_4d0b_bf33_49fe7dbc2a17, v_manager_id, 1950, 'cash', '', '2026-03-03 11:06:59.500838+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0abaebaf_0c19_4a3b_876e_3c7787bf39c0, v_manager_id, 2000, 'cash', '', '2026-03-11 07:37:16.434832+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7c46a2dc_ea73_4490_bcb2_1820d12c4a00, v_manager_id, 3700, 'cash', '', '2026-05-07 15:40:49.398989+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f764f45a_6193_4d16_ac5c_2d3a345c37e4, v_manager_id, 1950, 'cash', '', '2026-06-07 09:55:48.235+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_13f238bf_d58d_4fed_981d_2aef763d292b, v_manager_id, 1850, 'cash', '', '2026-06-13 14:39:00.938569+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ea6fb5b6_aa7e_439e_a17d_ad7354398615, v_manager_id, 3100, 'cash', '', '2026-02-25 11:52:04.364+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fe1afdcf_0fbe_4ce3_9087_05ec214db195, v_manager_id, 4200, 'cash', '', '2026-05-30 10:46:35.10478+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_289382f2_fff3_413d_8709_b19fbbffe488, v_manager_id, 3500, 'cash', '', '2026-06-30 15:36:37.725127+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5697b913_2fb0_4559_ba97_430a7c7f56ca, v_manager_id, 2000, 'cash', '', '2026-01-30 14:27:51.658932+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8261b4d3_9c5a_4a02_ac60_55338eebbe92, v_manager_id, 2000, 'cash', '', '2026-06-16 09:31:22.772475+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7b0575ca_e267_4e88_8b40_05fd387fdb35, v_manager_id, 1750, 'cash', '', '2026-06-27 08:30:15.171+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fb79ebce_ed8a_41a8_ada9_e12d3076f320, v_manager_id, 4500, 'cash', '', '2026-04-11 15:19:52.456383+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0721cbd0_fb36_4b2e_9c25_3931c8e11c9b, v_manager_id, 3700, 'cash', '', '2026-05-16 11:33:43.385181+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_1a363481_e9c7_45d2_b673_e806842a6d25, v_manager_id, 1500, 'cash', '', '2026-06-13 04:06:52.665+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e480a1aa_6e63_4ec0_9810_3a7b42f40bd5, v_manager_id, 7800, 'cash', '', '2026-01-26 10:01:32.049+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_286f7ca0_c98b_4946_9ac3_9b29b57f41bf, v_manager_id, 1850, 'cash', '', '2026-06-26 11:04:26.562516+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fd7a3c78_a3b1_473c_99d2_3e6a68cc7b41, v_manager_id, 4500, 'cash', '', '2026-03-10 07:54:22.239713+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8d7a8a39_3bbf_46f0_8db8_6399b0419819, v_manager_id, 3500, 'cash', '', '2026-04-21 08:29:24.933+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ea3d6785_b3f6_4a28_84a6_f5c8c9cfafee, v_manager_id, 2250, 'cash', '', '2026-06-04 12:35:55.716+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fa02ecff_3be5_4f97_875b_3d4cb1c1b818, v_manager_id, 1850, 'cash', '', '2026-05-11 14:36:46.334137+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_dba22eed_2047_40d1_80d2_b0a59d6597b8, v_manager_id, 1200, 'cash', '', '2026-06-09 14:21:13.143+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_00c6872a_7934_41ae_8ced_2e44bdf151db, v_manager_id, 3250, 'cash', '', '2026-02-13 11:41:47.665+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_accba925_dd84_42dd_9e95_4d427cfc0ff7, v_manager_id, 2250, 'cash', '', '2026-01-30 12:17:34.252962+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a53fa1bf_5d85_4dbb_8d49_e02f709520f5, v_manager_id, 1850, 'cash', '', '2026-06-30 15:08:45.600747+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5b15bc02_0ac0_435d_9843_0a93b1faa926, v_manager_id, 3480, 'cash', '', '2026-04-22 07:23:09.167462+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_aece34a9_9104_4573_9f65_985141f19357, v_manager_id, 2100, 'cash', '', '2026-03-05 07:11:42.54+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8950f0ae_c2f1_4030_a24a_504aae3a7fb5, v_manager_id, 2250, 'cash', '', '2026-04-06 11:05:50.600946+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fe9812d5_312d_4adb_a15e_e538495e782f, v_manager_id, 2100, 'cash', '', '2026-03-06 11:24:09.664564+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bdee4006_4124_4e6e_8217_dd20d8b98700, v_manager_id, 1900, 'cash', '', '2026-06-17 08:41:32.878804+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_19781198_57d6_42d0_ac22_3c7ab36b0172, v_manager_id, 1800, 'cash', '', '2026-06-19 15:57:59.937+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_dfcc12ab_1920_41a9_89df_7cfa22d9af44, v_manager_id, 1850, 'cash', '', '2026-06-18 12:50:00.166+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_22186ffa_a0c1_42f7_8551_031ef5e36a51, v_manager_id, 2400, 'cash', '', '2026-06-09 14:59:07.129+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a3fb828b_7ca8_4d33_b6a7_c1c4b403ec2e, v_manager_id, 3500, 'cash', '', '2026-02-18 10:10:55.633813+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8521ee7e_4b34_4ff3_a4d9_f5f8fd3a874d, v_manager_id, 1850, 'cash', '', '2026-06-22 15:43:22.415793+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_53dbdaee_db5d_41a2_b0f4_f0bcf3be1d83, v_manager_id, 1700, 'cash', '', '2026-02-18 16:47:03.6385+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_99259c02_9c66_4ba9_b3ad_d84d18fe8e3f, v_manager_id, 1700, 'cash', '', '2026-03-21 12:24:52.273+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6f830b7b_295e_4e46_bf1c_050eb8d343f3, v_manager_id, 1750, 'cash', '', '2026-01-16 10:24:14.765+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3482afba_01bc_4a9d_acda_11a75f11148a, v_manager_id, 1750, 'cash', '', '2026-03-28 09:06:59.635+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ea6fb5b6_aa7e_439e_a17d_ad7354398615, v_manager_id, 3100, 'cash', '', '2026-02-23 16:16:46.952699+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5dd8d2cd_ef81_4494_9caf_05555ba210c0, v_manager_id, 3000, 'cash', '', '2026-03-14 11:42:23.437237+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_04ac11e0_f980_430f_b891_ef0c764c4c6e, v_manager_id, 2000, 'cash', '', '2026-04-07 07:24:15.902738+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_1f113fa4_caad_4027_b97e_e0538dd372e9, v_manager_id, 5200, 'cash', '', '2026-02-28 10:29:30.027083+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4989e9bb_d092_47a8_9760_37eec9dff252, v_manager_id, 1850, 'cash', '', '2026-03-23 10:17:32.751+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_49da75db_91a6_4ef8_9009_1899e32178f8, v_manager_id, 3700, 'cash', '', '2026-02-19 17:14:01.956989+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_054e15de_3733_4e03_99b2_a994b362f130, v_manager_id, 1850, 'cash', '', '2026-06-03 12:01:15.56+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9b99394f_dcb3_478d_965d_8964f9b52fee, v_manager_id, 2000, 'cash', '', '2026-04-28 10:32:21.766129+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3448b53b_7832_4136_903d_554c40f9267d, v_manager_id, 1850, 'cash', '', '2026-04-05 06:20:57.722437+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6799485b_6976_4e50_9e5f_54c614b2895a, v_manager_id, 3950, 'cash', '', '2026-06-23 07:39:31.93703+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_accba925_dd84_42dd_9e95_4d427cfc0ff7, v_manager_id, 2250, 'cash', '', '2026-02-14 11:32:22.483+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9682092d_8b58_47cc_b8e7_9b3a0a2048a6, v_manager_id, 6050, 'cash', '', '2026-02-07 13:14:47.121+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9f804260_235b_4866_bceb_9e0854b41bfa, v_manager_id, 1850, 'cash', '', '2026-04-18 11:36:54.548146+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4391054d_3169_49ab_b62b_7f75f3f534aa, v_manager_id, 1850, 'cash', '', '2026-06-05 06:58:19.493+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d58b52d9_9f36_49b2_afdf_6c326413a8e0, v_manager_id, 3700, 'cash', '', '2026-03-07 11:48:53.939843+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_23c08a40_0585_4137_9418_64379817de46, v_manager_id, 2250, 'cash', '', '2026-05-16 07:49:58.849+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bf43df83_504a_4e4c_a028_92cc2eff10e7, v_manager_id, 2500, 'cash', '', '2026-04-04 14:20:36.378+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bb1c9fe9_9aa1_4b6c_9a57_c54576ed3e14, v_manager_id, 1850, 'cash', '', '2026-03-25 09:48:20.173954+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_229ce27a_279c_45e7_acce_e657728c7771, v_manager_id, 1700, 'cash', '', '2026-04-06 08:08:36.794+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e31fbc9b_3149_4782_acf8_9c291497b650, v_manager_id, 2000, 'cash', '', '2026-06-11 11:59:32.080865+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_66378964_5e20_49cf_b146_f5001352ef45, v_manager_id, 1500, 'cash', '', '2026-06-29 12:15:10.403+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4405f45e_9552_4e65_bb2b_ecee6b36d025, v_manager_id, 6400, 'cash', '', '2026-01-10 15:00:22.598214+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8d7f8b0f_e3e8_47ec_be33_4827e10673db, v_manager_id, 3500, 'cash', '', '2026-06-13 13:35:30.277009+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0b790c27_d52f_49d5_bac1_b388e6d1eeeb, v_manager_id, 2700, 'cash', '', '2026-03-06 14:26:02.30171+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_18b284f3_3738_4f9c_b05c_02a863e1a06a, v_manager_id, 3700, 'cash', '', '2026-06-27 10:15:50.274727+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_26560755_83c8_4d76_a7e1_c07f7f97e3b9, v_manager_id, 1850, 'cash', '', '2026-05-15 14:52:23.752016+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4d908ed0_f0c3_48c5_b88e_56428ec77fe9, v_manager_id, 3700, 'cash', '', '2026-05-23 11:06:37.268204+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9682092d_8b58_47cc_b8e7_9b3a0a2048a6, v_manager_id, 6050, 'cash', '', '2026-02-03 10:16:07.874171+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0b790c27_d52f_49d5_bac1_b388e6d1eeeb, v_manager_id, 2500, 'cash', '', '2026-03-18 15:32:38.445+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_aefbd269_d04d_4399_87ea_a8fe803e89dd, v_manager_id, 2100, 'cash', '', '2026-06-16 12:19:27.83606+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f1af0790_134b_4fae_be53_44bc1776dad0, v_manager_id, 2500, 'cash', '', '2026-06-23 13:58:09.730158+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_82b93d86_6cb4_4d7b_a7d9_ba7bf284e29d, v_manager_id, 3125, 'cash', '', '2026-02-26 11:47:57.682+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e4deadf4_bd02_4a34_a41c_92039c0ba013, v_manager_id, 3700, 'cash', '', '2026-06-30 14:30:03.430759+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9d7f62ce_c8e5_486d_8022_f9f7a402e7e9, v_manager_id, 2100, 'cash', '', '2026-06-29 14:40:56.123225+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c61f3fd4_49c5_499d_b26a_1333637d8c82, v_manager_id, 3700, 'cash', '', '2026-03-11 08:53:49.556767+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a40235af_9568_4d59_9ead_9cd613a6c9f2, v_manager_id, 1500, 'cash', '', '2026-02-09 07:54:19.451996+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d38bbc6e_cc01_4c79_8f44_f1febbd767dd, v_manager_id, 1500, 'cash', '', '2026-06-23 17:26:26.246937+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d934c8a7_42ca_472d_b70b_70631e7bce0f, v_manager_id, 1750, 'cash', '', '2026-02-04 14:16:39.098+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c4100220_789a_4861_bb1a_d7d7ddca83cc, v_manager_id, 2350, 'cash', '', '2026-01-19 07:11:04.009177+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_cf934039_36d0_44cc_a76e_0e76ae15ee04, v_manager_id, 3000, 'cash', '', '2026-06-29 14:53:31.40363+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9604b4e7_c559_47dc_9ec4_0c3224c0586e, v_manager_id, 1850, 'cash', '', '2026-06-14 07:47:13.188762+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_97daf4f4_7475_46c4_a3eb_a1c13706b4ef, v_manager_id, 2100, 'cash', '', '2026-06-03 11:22:59.784+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d4079abd_86f7_4b24_85ff_b71e5b4ed5ad, v_manager_id, 3500, 'cash', '', '2026-01-26 09:43:48.216325+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3f02ebe6_f3cd_4341_b825_d392e5abdbe0, v_manager_id, 3700, 'cash', '', '2026-04-03 14:36:41.049317+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bb35a857_08f1_41e3_a121_2440680ddd88, v_manager_id, 2000, 'cash', '', '2026-03-25 14:31:43.637065+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_58387986_c2f4_48fb_9721_cc90a4936c05, v_manager_id, 2000, 'cash', '', '2026-01-30 16:35:55.683845+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_61860dd4_8965_4fef_aeb3_2a63dbb15d03, v_manager_id, 1800, 'cash', '', '2026-06-09 13:50:21.736+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_cc1ff338_f6bd_4a87_8d94_1e131a7ca25e, v_manager_id, 2500, 'cash', '', '2026-05-21 16:11:19.888+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_425f4714_ca96_417d_af0f_c98af89abf59, v_manager_id, 6500, 'cash', '', '2026-03-02 08:13:52.188535+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4405f45e_9552_4e65_bb2b_ecee6b36d025, v_manager_id, 2000, 'cash', '', '2026-01-24 10:50:20.699+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_77c255a0_3976_437b_8615_da325d350b88, v_manager_id, 1800, 'cash', '', '2026-04-15 15:35:02.159+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e7a07563_ffb1_4f9e_8fe8_18b6ee4a5d2d, v_manager_id, 10000, 'cash', '', '2026-03-19 14:12:51.448408+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_82b93d86_6cb4_4d7b_a7d9_ba7bf284e29d, v_manager_id, 3125, 'cash', '', '2026-02-23 11:48:48.114176+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fbfffea4_6630_4551_bde1_39d21774d2cb, v_manager_id, 7450, 'cash', '', '2026-06-17 15:36:56.15+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0d0aa9c4_adc2_4aae_92a0_b3b044e9e02e, v_manager_id, 3700, 'cash', '', '2026-06-30 14:34:27.645712+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_32971693_a74c_4d48_a189_fd079dba1aa6, v_manager_id, 7750, 'cash', '', '2026-02-07 14:27:46.066+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_78406b3d_c539_4ff2_aa63_d645c8484110, v_manager_id, 4200, 'cash', '', '2026-04-21 08:55:29.497041+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0abaebaf_0c19_4a3b_876e_3c7787bf39c0, v_manager_id, 2500, 'cash', '', '2026-03-13 16:27:19.65+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7cd6c67b_7f77_4f33_878f_34d083f3d4a0, v_manager_id, 1750, 'cash', '', '2026-05-15 08:44:53.715365+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9f804260_235b_4866_bceb_9e0854b41bfa, v_manager_id, 1850, 'cash', '', '2026-04-28 08:08:45.731+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e7384974_4bbf_452f_b639_e440091a1d18, v_manager_id, 3500, 'cash', '', '2026-02-27 15:17:42.289519+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b78cf955_d66d_42d6_be32_0a267057e913, v_manager_id, 1850, 'cash', '', '2026-02-09 12:49:50.501288+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4989e9bb_d092_47a8_9760_37eec9dff252, v_manager_id, 1850, 'cash', '', '2026-03-20 08:27:34.014092+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e99e4999_929b_48c2_820f_337864586030, v_manager_id, 7000, 'cash', '', '2026-04-11 11:48:09.741+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3997f029_23d9_4ab0_8b52_ee512bffe7ac, v_manager_id, 3700, 'cash', '', '2026-03-16 13:54:15.114695+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bb8fd263_323a_4762_85f2_964a69a3f9fa, v_manager_id, 1850, 'cash', '', '2026-05-05 11:14:26.918927+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a28626e1_b94e_4dc2_a840_ba6a2e553b52, v_manager_id, 1900, 'cash', '', '2026-02-05 09:33:10.466404+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_804a16a7_1633_4e07_b3c3_7a54b7353ab0, v_manager_id, 1975, 'cash', '', '2026-06-29 14:38:31.249738+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e6e932ee_6cb1_4972_8e9b_8fda8ca1fe10, v_manager_id, 3700, 'cash', '', '2026-04-02 12:48:18.458474+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a97db74f_f2ed_46cc_aae9_7b4661cd79cb, v_manager_id, 3750, 'cash', '', '2026-03-04 06:45:49.336836+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_17f1a5f1_0f0b_4629_82a7_4926ce3440af, v_manager_id, 7250, 'cash', '', '2026-03-17 06:45:03.391+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ac11b3b2_536a_4fa0_a59c_10245558fa35, v_manager_id, 5000, 'cash', '', '2026-05-23 14:31:09.751+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bb8fd263_323a_4762_85f2_964a69a3f9fa, v_manager_id, 1850, 'cash', '', '2026-05-08 11:08:16.386+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_78844f7c_db9e_403d_9167_727a35e4e7c9, v_manager_id, 1850, 'cash', '', '2026-02-19 08:07:51.254+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_38aa44a8_4682_4980_a838_3b305615dcbf, v_manager_id, 1900, 'cash', '', '2026-06-04 08:04:15.383973+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_99259c02_9c66_4ba9_b3ad_d84d18fe8e3f, v_manager_id, 2000, 'cash', '', '2026-03-18 12:14:44.136954+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2a01f1d7_4a6d_4389_a151_47b2c25403e2, v_manager_id, 1850, 'cash', '', '2026-04-18 13:21:00.46+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8d3f6d93_8b43_45cb_8ee2_261fcda8d7a6, v_manager_id, 2500, 'cash', '', '2026-06-09 06:45:52.182287+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9604b4e7_c559_47dc_9ec4_0c3224c0586e, v_manager_id, 1850, 'cash', '', '2026-06-18 16:29:53.959+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f30fe4da_ef57_45e4_8cfc_159cc13df92f, v_manager_id, 3700, 'cash', '', '2026-02-25 11:45:55.098305+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c02ea85e_e8e1_40a4_b2ab_f8850044d54c, v_manager_id, 1950, 'cash', '', '2026-06-05 07:29:32.298+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c9867a7f_463c_4172_b188_e7c396d5f791, v_manager_id, 2200, 'cash', '', '2026-05-09 13:12:52.224+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5706a438_9448_4283_9e93_9d03d3487387, v_manager_id, 3700, 'cash', '', '2026-06-08 16:11:53.654468+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_dfcc12ab_1920_41a9_89df_7cfa22d9af44, v_manager_id, 1850, 'cash', '', '2026-06-15 14:34:26.551778+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ac11b3b2_536a_4fa0_a59c_10245558fa35, v_manager_id, 10000, 'cash', '', '2026-05-07 06:31:38.303272+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_79e4949a_2daa_46cb_b4e4_0761605c1be2, v_manager_id, 1850, 'cash', '', '2026-05-01 15:27:44.434152+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bc73605a_df11_49ee_bc70_b23c8a193f00, v_manager_id, 1850, 'cash', '', '2026-04-21 11:01:27.236+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_89b59b57_aa1b_4ee7_9edc_bf580b89b3db, v_manager_id, 2450, 'cash', '', '2026-06-30 11:26:07.132+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2d2cde47_49a7_4c24_b4f7_a8091ff2c599, v_manager_id, 1850, 'cash', '', '2026-06-10 10:41:48.406586+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6f830b7b_295e_4e46_bf1c_050eb8d343f3, v_manager_id, 1750, 'cash', '', '2026-01-16 10:24:02.315+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d09c6c70_cf9a_4e8a_a26b_0416cb01e121, v_manager_id, 3500, 'cash', '', '2026-05-28 15:27:30.125626+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5cde6ba5_95c7_4df0_a8e2_56b8ec4d0081, v_manager_id, 4000, 'cash', '', '2026-02-25 09:58:35.570789+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d73d75ff_8345_4c4d_9d2b_3d7e4dba0ae8, v_manager_id, 4200, 'cash', '', '2026-02-19 15:00:32.047412+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_29842f94_1ad9_4bdb_bd71_7299953026a7, v_manager_id, 3700, 'cash', '', '2026-05-20 12:46:01.316623+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5b487d29_8d17_4973_a4ba_7070366941e3, v_manager_id, 3700, 'cash', '', '2026-04-04 11:33:20.472082+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ebf91396_e436_46e9_a28d_3b0a7eaa6811, v_manager_id, 1850, 'cash', '', '2026-06-08 14:29:12.273479+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0298153c_9662_4865_97f3_7baeec6f1a70, v_manager_id, 4700, 'cash', '', '2026-06-23 10:38:35.890578+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b6bb2e2b_a9e6_4cef_87f2_318839f642d3, v_manager_id, 2100, 'cash', '', '2026-04-27 10:13:45.075+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3f4990d9_d1bf_4f4d_865c_72c50d27bb10, v_manager_id, 1750, 'cash', '', '2026-06-19 11:12:30.256+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7b0575ca_e267_4e88_8b40_05fd387fdb35, v_manager_id, 1750, 'cash', '', '2026-06-25 06:30:37.060114+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_aefbd269_d04d_4399_87ea_a8fe803e89dd, v_manager_id, 2100, 'cash', '', '2026-06-23 14:27:08.691+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_82df5a29_2b2b_4d88_b3ff_c51eb6bd4f9f, v_manager_id, 2350, 'cash', '', '2026-06-03 11:50:50.280943+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_10985031_5124_4519_b293_5e38a42f79f3, v_manager_id, 7200, 'cash', '', '2026-04-10 16:14:20.063008+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3fee883f_f1d0_487d_8d23_1abac51bf70d, v_manager_id, 3700, 'cash', '', '2026-06-09 12:01:09.449473+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9b99394f_dcb3_478d_965d_8964f9b52fee, v_manager_id, 2700, 'cash', '', '2026-05-06 13:30:32.526+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_79e4949a_2daa_46cb_b4e4_0761605c1be2, v_manager_id, 1850, 'cash', '', '2026-05-06 12:22:51.732+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a9368b86_daef_418c_985b_14b8ef8be401, v_manager_id, 1750, 'cash', '', '2026-03-15 08:58:38.312696+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f2691492_ea8c_4b55_8319_fe0aa82c09d5, v_manager_id, 1700, 'cash', '', '2026-01-30 16:33:34.399+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_adfd2172_08cc_4db6_a736_abac7938d514, v_manager_id, 2100, 'cash', '', '2026-06-01 06:21:55.095202+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7f6b6bbc_2106_49d4_9514_326c22273f8c, v_manager_id, 3500, 'cash', '', '2026-01-29 09:34:08.435684+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_da0b50a1_679d_4598_9598_0dfcc381f733, v_manager_id, 1975, 'cash', '', '2026-03-11 12:42:42.925091+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2fb322cd_1418_4839_a3f7_5ae44026781a, v_manager_id, 1750, 'cash', '', '2026-06-24 15:43:22.091+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3bc18eda_fcbf_4f54_a3cd_47d1af2b1e27, v_manager_id, 1750, 'cash', '', '2026-06-30 09:38:38.756553+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_81588e07_d811_411c_bd76_e0c0241f5502, v_manager_id, 4200, 'cash', '', '2026-06-23 09:50:18.124386+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2567af9f_3253_4ab1_80c7_cffe58c6653f, v_manager_id, 2100, 'cash', '', '2026-02-19 09:55:20.502+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b0c23acf_2622_4fde_81de_793d8e524a7d, v_manager_id, 1700, 'cash', '', '2026-06-02 16:49:26.323+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_691595ad_1436_49da_8d21_fd9468670b75, v_manager_id, 2000, 'cash', '', '2026-02-20 07:11:31.083267+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fec347e8_9ce4_4bca_8e79_e7ee0fcbbb12, v_manager_id, 2000, 'cash', '', '2026-06-19 11:06:33.441091+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_38aa44a8_4682_4980_a838_3b305615dcbf, v_manager_id, 1800, 'cash', '', '2026-06-10 06:50:35.202+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b78cf955_d66d_42d6_be32_0a267057e913, v_manager_id, 1850, 'cash', '', '2026-02-17 08:51:27.058+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_5983e0fc_5714_44d8_b90d_8e3b530e212b, v_manager_id, 1700, 'cash', '', '2026-06-29 12:37:29.684+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_4851c661_1070_4925_b930_685d6c80aa20, v_manager_id, 3500, 'cash', '', '2026-05-30 09:17:15.433957+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_58387986_c2f4_48fb_9721_cc90a4936c05, v_manager_id, 1500, 'cash', '', '2026-02-07 14:37:18.811+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_02801f54_cdac_4bec_b732_13a41ae6ccca, v_manager_id, 2500, 'cash', '', '2026-01-27 13:18:42.630331+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f48a91fd_23bd_4163_8062_710857a88633, v_manager_id, 1850, 'cash', '', '2026-05-25 10:36:39.578+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a1f6cc5a_b6ff_4bc4_9a2a_7c4a0cf14dd0, v_manager_id, 3000, 'cash', '', '2026-02-10 12:14:46.170949+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fd1a5bd6_3589_4045_8cb6_a04d0fd404d0, v_manager_id, 1700, 'cash', '', '2026-06-08 13:15:49.977+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_353a301d_6989_451a_865f_a075708768ce, v_manager_id, 2350, 'cash', '', '2026-03-27 15:05:34.279+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2edc0c90_0ddd_44ec_9bd8_39ed5d739dbd, v_manager_id, 1500, 'cash', '', '2026-04-10 11:10:27.247738+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_41b0f602_b136_4702_a000_f96a51a77693, v_manager_id, 2750, 'cash', '', '2026-01-21 10:12:17.554634+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_ea0ff900_5c06_4a3d_b41d_cd09463d8235, v_manager_id, 2000, 'cash', '', '2026-05-30 10:25:18.486119+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c5455c86_d08c_433f_a864_03465bc82262, v_manager_id, 4500, 'cash', '', '2026-06-29 16:03:42.881466+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_3387c183_ffb3_46b6_a7a3_d03bb748da5c, v_manager_id, 1850, 'cash', '', '2026-06-29 14:15:43.384463+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_437b69fd_69ed_4ddb_ad56_4e22e0ee49a4, v_manager_id, 7000, 'cash', '', '2026-05-11 11:09:41.367364+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_991ded7f_c47d_457b_977a_75f06f924164, v_manager_id, 2100, 'cash', '', '2026-03-26 05:42:18.329+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e480a1aa_6e63_4ec0_9810_3a7b42f40bd5, v_manager_id, 4100, 'cash', '', '2026-01-20 11:23:50.97781+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bf43df83_504a_4e4c_a028_92cc2eff10e7, v_manager_id, 4000, 'cash', '', '2026-02-25 10:01:44.87581+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_691595ad_1436_49da_8d21_fd9468670b75, v_manager_id, 1700, 'cash', '', '2026-02-27 08:52:30.468+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d2f81793_c3a4_475d_8c08_331bb0036ebd, v_manager_id, 5500, 'cash', '', '2026-02-27 16:15:54.738+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_37ba72c1_8280_4b59_9cd9_ba6c9e1eab28, v_manager_id, 2000, 'cash', '', '2026-06-02 10:48:27.674365+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_70a9b8ef_090e_48a3_926e_ef8f44a597b0, v_manager_id, 3700, 'cash', '', '2026-03-07 11:07:03.026476+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_13f238bf_d58d_4fed_981d_2aef763d292b, v_manager_id, 1850, 'cash', '', '2026-06-27 14:06:30.021+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_da1645e8_ab69_44a3_b80a_380403bed46f, v_manager_id, 3700, 'cash', '', '2026-05-28 10:00:58.119574+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9da98588_ec9b_4022_9126_eb706555892b, v_manager_id, 1850, 'cash', '', '2026-02-11 11:45:05.818+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9f1a3225_c288_46dd_bea8_fc03f9ded09f, v_manager_id, 3750, 'cash', '', '2026-06-26 15:49:18.35+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_17e43ff7_f45d_4b4a_83d5_66f5558b176a, v_manager_id, 7500, 'cash', '', '2026-06-22 10:10:07.654821+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_08091250_d494_443e_b419_a28e349bdef4, v_manager_id, 2200, 'cash', '', '2026-06-02 10:15:55.915+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_e6cd6425_1b1e_48ad_9ce1_f011b42700b8, v_manager_id, 1850, 'cash', '', '2026-05-23 06:23:34.269348+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6183e2ec_e0bd_4b32_995e_a60d46116da6, v_manager_id, 1850, 'cash', '', '2026-04-01 13:48:17.983043+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_fd1a5bd6_3589_4045_8cb6_a04d0fd404d0, v_manager_id, 2000, 'cash', '', '2026-06-05 17:46:10.314747+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_311299d8_f229_49e1_8122_ef4d74dbea85, v_manager_id, 3700, 'cash', '', '2026-04-10 10:28:35.807466+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f907fe28_822b_4ae6_b536_ca40d46f5eb3, v_manager_id, 1850, 'cash', '', '2026-06-13 12:27:03.322135+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_c45bbf5f_b432_4912_af20_d15a24cfcec6, v_manager_id, 3700, 'cash', '', '2026-02-02 14:14:06.898808+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_cf92d330_89d8_4ea4_9b9d_222a91f522cc, v_manager_id, 4000, 'cash', '', '2026-03-13 12:12:05.837151+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_6f830b7b_295e_4e46_bf1c_050eb8d343f3, v_manager_id, 1750, 'cash', '', '2026-01-13 18:03:06.013754+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_0626eac1_6293_4418_bafc_41a8daeffa3c, v_manager_id, 4200, 'cash', '', '2026-06-17 11:00:41.316681+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_7b83db63_5fbc_4d0e_9c4c_718a38a89ff8, v_manager_id, 1200, 'cash', '', '2026-06-17 12:09:26.782+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_12819aa5_d08a_42ac_bf04_89bb07d2b9ed, v_manager_id, 3700, 'cash', '', '2026-03-13 14:40:05.738541+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_55e127ad_33e3_4e8b_a119_f3a0db1c5fd4, v_manager_id, 1850, 'cash', '', '2026-05-16 07:48:50.732+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_528677f0_99bd_4ff0_b7dd_df2d6b7b6188, v_manager_id, 2100, 'cash', '', '2026-04-11 12:41:07.163504+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_aece34a9_9104_4573_9f65_985141f19357, v_manager_id, 2100, 'cash', '', '2026-03-03 14:27:28.009372+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_8544e6c6_ba3f_4da3_94a0_9e0dc55eae34, v_manager_id, 3000, 'cash', '', '2026-03-17 15:11:28.310285+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_bb35a857_08f1_41e3_a121_2440680ddd88, v_manager_id, 2500, 'cash', '', '2026-03-30 12:28:34.015+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_1a363481_e9c7_45d2_b673_e806842a6d25, v_manager_id, 2000, 'cash', '', '2026-06-12 14:08:43.079793+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b19018d6_fe68_4d0b_bf33_49fe7dbc2a17, v_manager_id, 1950, 'cash', '', '2026-03-06 11:05:28.871+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_41ad28d3_28e0_4d62_832e_d8fffdb4a847, v_manager_id, 1750, 'cash', '', '2026-06-22 11:10:15.975+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_23c08a40_0585_4137_9418_64379817de46, v_manager_id, 2250, 'cash', '', '2026-05-12 11:20:27.011588+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d8abce89_d595_4c52_b92a_6dfaf9cf407d, v_manager_id, 3700, 'cash', '', '2026-04-24 15:55:21.411692+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_2fb322cd_1418_4839_a3f7_5ae44026781a, v_manager_id, 1750, 'cash', '', '2026-06-22 15:40:37.11785+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_f26883c1_d830_4871_ab5b_d1b5a8fff409, v_manager_id, 2100, 'cash', '', '2026-06-01 08:23:02.682969+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_d3773cfd_58b3_46ce_b3ef_813c2043608e, v_manager_id, 3700, 'cash', '', '2026-06-30 13:42:14.919719+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_a28626e1_b94e_4dc2_a840_ba6a2e553b52, v_manager_id, 2050, 'cash', '', '2026-02-09 13:46:11.189+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_57d1fa50_51df_4c56_af97_fe657f6db46a, v_manager_id, 4500, 'cash', '', '2026-04-13 14:07:47.260198+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_9907dec6_d185_4f60_a32e_04f8f99383cc, v_manager_id, 3000, 'cash', '', '2026-06-30 11:16:06.891141+00');
INSERT INTO public.payments (organization_id, order_id, manager_id, amount, payment_method, notes, recorded_at) 
VALUES (v_org_id, v_order_b47e1c5e_ded4_482e_8068_fe426bd62aad, v_manager_id, 4500, 'cash', '', '2026-06-02 13:47:34.838691+00');

END $$;
