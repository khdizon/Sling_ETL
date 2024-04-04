-- Package Function 

    CASE -- # Function: Package Details
        -- Core
	 	WHEN acnt_core_typ_cd = 'DOMESTIC' THEN 'Orange'
        WHEN acnt_core_typ_cd = 'DOMESTIC-MSS' THEN 'Blue'
		WHEN acnt_core_typ_cd = 'DOMESTIC/DOMESTIC-MSS' THEN 'Combo'
        --International
        WHEN acnt_core_typ_cd = 'INTERNATIONAL' THEN 'International'
        WHEN acnt_core_typ_cd = 'DOMESTIC/INTERNATIONAL' THEN 'Orange International'
        WHEN acnt_core_typ_cd = 'DOMESTIC-MSS/INTERNATIONAL' THEN 'Blue International'
        WHEN acnt_core_typ_cd = 'DOMESTIC/DOMESTIC-MSS/INTERNATIONAL' THEN 'Combo International'
        -- Latino
        WHEN acnt_core_typ_cd = 'LATINO' THEN 'Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC/LATINO' THEN 'Orange Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC-MSS/LATINO' THEN 'Blue Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC/DOMESTIC-MSS/LATINO' THEN 'Combo Latino'
        -- International/Latino/Combo
        WHEN acnt_core_typ_cd = 'INTERNATIONAL/LATINO' THEN 'International/Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC/INTERNATIONAL/LATINO' THEN 'Orange/International/Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC-MSS/INTERNATIONAL/LATINO' THEN 'Blue/International/Latino'
        WHEN acnt_core_typ_cd = 'DOMESTIC/DOMESTIC-MSS/INTERNATIONAL/LATINO' THEN 'Combo/Internation/Latino'
        -- Other
        ELSE 'Unknow'
    END AS package_name,



-- Package Function # 2 Using All the Core + Add ons
    CASE -- # Function: Package Details
        WHEN acnt_core_typ_cd IN (
            'DOMESTIC',
            'DOMESTIC/INTERNATIONAL',
            'DOMESTIC/LATINO',
            'DOMESTIC/INTERNATIONAL/LATINO',
        ) THEN 'Orange'
        
        WHEN acnt_core_typ_cd IN (
            'DOMESTIC-MSS',
            'DOMESTIC-MSS/INTERNATIONAL',
            'DOMESTIC-MSS/LATINO',
            'DOMESTIC-MSS/INTERNATIONAL/LATINO',
        ) THEN 'Blue'
        
        WHEN acnt_core_typ_cd IN (
            'DOMESTIC/DOMESTIC-MSS',
            'DOMESTIC/DOMESTIC-MSS/INTERNATIONAL',
            'DOMESTIC/DOMESTIC-MSS/LATINO',
            'DOMESTIC/DOMESTIC-MSS/INTERNATIONAL/LATINO',
        ) THEN 'Combo'

        -- Other
        ELSE 'Unknow'
    END AS package_name,