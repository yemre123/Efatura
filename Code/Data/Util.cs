using System;
using DevExpress.Xpo.DB;
using DevExpress.Xpo;
using System.Configuration;

namespace Data
{
    public static class Util
    {
        public static Engine En;

        static Util()
        {
            En = new Engine();
        }
    }

    public static class XP
    {
        static DevExpress.Xpo.Session _session = null;

        public static void Connect(string ConnStr)
        {
            // create database
            DevExpress.Xpo.IDataLayer simpleLayer = DevExpress.Xpo.XpoDefault.GetDataLayer(ConnStr,
                 DevExpress.Xpo.DB.AutoCreateOption.DatabaseAndSchema);

            //XpoDefault.DataLayer = XpoDefault.GetDataLayer(ConnStr, AutoCreateOption.DatabaseAndSchema);              
            XpoDefault.DataLayer = simpleLayer;
            _session = new DevExpress.Xpo.Session();

            DbGenerate();
            
            _session.UpdateSchema();
        }


        static void DbGenerate()
        {
            ToDb db = new ToDb();

            if (!db.IsView("BORCLAR"))
            {
                db.CreateView("BORCLAR", @"SELECT     CAST(per.TRDATE AS DATETIME) AS TARIH, per.PERCODE AS SICILNO, pr.NAME, pr.SURNAME, 
                      CASE per.FIRMNR WHEN 1 THEN '001 İSTANBUL OTOBÜS İŞLETMELERİ TİCARET A.Ş.' END AS KURUM, 
                      CASE per.DEPTNR WHEN 0 THEN '0000 GENEL MÜDÜRLÜK' WHEN 7 THEN '0007 YÖNETİM KURULU' END AS BOLUM, 
                      CASE per.LOCNR WHEN 0 THEN '0000 İSTANBUL OTOBÜS A.Ş.-MERKEZ' END AS IS_YERI, loa.CODE AS BORC_KODU, loa.DEFINITION_ AS BORC_TANIMI, 
                      per.DEBIT AS BORC_TUTARI, CASE REQCURRTYPE WHEN 160 THEN 'TL' END AS DOVIZ_TURU, 
                      CASE per.TRTYPE WHEN 1 THEN 'Borçlandırma' WHEN 2 THEN 'Geri Ödeme' WHEN 3 THEN 'Kapama' END AS ISLEM_TURU, 
                      CASE per.PAYSTYLE WHEN 1 THEN 'Elden' WHEN 2 THEN 'Kasadan' WHEN 3 THEN 'Bankadan' WHEN 4 THEN 'Puantajdan' WHEN 5 THEN 'Belge İle' END AS ODEME_SEKLI,
                       per.LREF, per.NOTENUM AS TAKSIT_SAYISI, per.ACTDATE AS ODEME_TARIHI, per.NOTEAMOUNT AS TAKSIT_TUTARI
FROM         BORDRODB.dbo.LH_001_LOANDEF AS loa WITH (nolock) INNER JOIN
                      BORDRODB.dbo.LH_001_PERLOAN AS per WITH (nolock) ON loa.LREF = per.CARDREF INNER JOIN
                      BORDRODB.dbo.LH_001_PERSON AS pr WITH (nolock) ON per.PERREF = pr.LREF");
            }

            if (!db.IsView("BORCTANIMLARI"))
            {
                db.CreateView("BORCTANIMLARI", @"SELECT     CODE, DEFINITION_, LREF, TYP
                                                FROM         BORDRODB.dbo.LH_001_LOANDEF");
            }

            if (!db.IsView("IZINLER"))
            {
                db.CreateView("IZINLER", @"SELECT TOP (100) PERCENT p.CODE, p.NAME, p.SURNAME, v.YEAR_ AS YIL, CAST(v.TOTVACNUMBER AS NVARCHAR) + ' gün' AS HAKEDILEN_IZIN, CAST(v.USEDNUMBER AS NVARCHAR) 
            + ' gün' AS KULLANILAN_IZIN, CAST(v.TRANSNUMBER AS VARCHAR) + ' gün' AS DEVREDEN, CAST(v.WASUSEDNUMBER AS NVARCHAR) + ' gün' AS KULLANILMIS_IZIN, 
            CAST(v.TOTVACNUMBER - v.USEDNUMBER AS NVARCHAR) + ' gün' AS BAKIYE, v.PERREF, v.LREF
FROM   BORDRODB.dbo.LH_001_PERSON AS p INNER JOIN
            BORDRODB.dbo.LH_001_VACTRANS AS v ON p.LREF = v.PERREF
WHERE (v.YEAR_ <> 1900)
ORDER BY p.CODE DESC");
            }

            if (!db.IsView("IZINTANIM"))
            {
                db.CreateView("IZINTANIM", @"SELECT     TOP (100) PERCENT P.CODE, P.NAME, P.SURNAME, B.CODE AS Expr1, B.EXP, CONVERT(VARCHAR(10), A.BEGDATE, 104) AS Expr2, CONVERT(VARCHAR(10), 
                      A.ENDDATE, 104) AS Expr3, CAST(A.PERIOD AS NVARCHAR) + ' gün' AS PERIOD, A.LREF, 
                      CASE A.ACTIVITYREF WHEN 0 THEN 'Plan' WHEN 1 THEN 'Gerçekleşti' WHEN 2 THEN 'İptal' WHEN 3 THEN 'Ertelendi' WHEN 4 THEN 'Onaylandı' END AS DURUM
FROM         BORDRODB.dbo.LH_001_PERSON AS P INNER JOIN
                      BORDRODB.dbo.LH_001_ACTPLNLN AS A ON A.PERREF = P.LREF INNER JOIN
                      BORDRODB.dbo.LH_001_ACTIVITY AS B ON A.ACTIVITYREF = B.LREF
ORDER BY P.CODE DESC");
            }

            if (!db.IsView("PUANTAJKARTDETAY"))
            {
                db.CreateView("PUANTAJKARTDETAY", @"SELECT     TOP (100) PERCENT person.CODE AS SICILNO, person.NAME AS ADI, person.SURNAME AS SOYADI, 
                      CASE person.FIRMNR WHEN 1 THEN '001 İSTANBUL OTOBÜS İŞLETMELERİ TİCARET A.Ş.' END AS KURUM, 
                      CASE person.DEPTNR WHEN 0 THEN '0000 GENEL MÜDÜRLÜK' WHEN 7 THEN '0007 YÖNETİM KURULU' END AS BOLUM, 
                      CASE person.LOCNR WHEN 0 THEN '0000 İSTANBUL OTOBÜS A.Ş.-MERKEZ' END AS IS_YERI, capiunit.NAME AS BIRIM, CONVERT(VARCHAR(10), pntline.PERDBEG, 
                      103) AS DONEM_BASI, pntline.LNNR AS SATIRNO, 
                      CASE WHEN pntline.LNNR = 1 THEN 'SGK Primine Esas Gün' WHEN pntline.LNNR = 2 THEN 'Vergi Ödeme Günü' WHEN pntline.LNNR = 3 THEN 'Toplam Çalışma Günü'
                       ELSE payelem.DEFINITION_ END AS ACIKLAMA, pntline.TYP AS TURU, pntline.NR, pntline.DAY_ AS GUN, pntline.HOUR_ AS SAAT, pntline.COEFF AS KATSAYI, 
                      pntline.TRTYPE AS SATIR_TIPI, CASE pntline.CLCTYPE WHEN 1 THEN 'Net' WHEN 2 THEN 'Brüt' END AS HESAPLAMA_SEKLI, 
                      CASE pntline.OPTYPE WHEN 1 THEN 'Ay' WHEN 2 THEN 'Gün' WHEN 3 THEN 'Saat' END AS ODEME_TIPI, 
                      CASE pntline.PAYABLE WHEN 0 THEN 'Ayni' WHEN 1 THEN 'Nakdi' END AS ODEME_SEKLI, CONVERT(VARCHAR(15), CAST(pntline.AMNT AS MONEY), 1) 
                      AS BIRIM_TUTAR, CASE pntline.CURRTYPE WHEN 160 THEN 'TL' WHEN 1 THEN 'USD' END AS DOVIZ_TURU, CONVERT(VARCHAR(15), 
                      CAST(pntline.GROSSAM AS MONEY), 1) AS TOPLAM_TUTAR, CONVERT(VARCHAR(15), CAST(pntline.NETAM AS MONEY), 1) AS NET_TUTAR, 
                      pntline.BOSSAM AS ISVEREN_PAYI, pntline.SIGN, pntline.BASE AS DUZENLEME_TABANI, pntline.PAIDPORT AS NAKIT_KISMI, pntline.TRDATE AS ISLEM_TARIHI, 
                      pntline.TAXEXCL AS VERGI_ISTISNA_TUTARI, pntcard.PERDEND, pntcard.BALN_WORKS_PTD AS MESAILER_TOPLAMI, 
                      CASE perfin.SSKSTATUS WHEN 1 THEN '4/a Normal' WHEN 2 THEN '4/a Emekli' WHEN 3 THEN '4/a Çyrak' WHEN 4 THEN '4/a Stajyer' WHEN 5 THEN '4/a Yabancı' WHEN
                       8 THEN 'Diğer' END AS SSKSTATUS, 
                      CASE PNTCARD.SSKMDAYREASON WHEN 0 THEN 'Yok' WHEN 1 THEN '1.HASTALIK' WHEN 2 THEN '2.Ücretsiz İzin' WHEN 3 THEN '3.Disiplin Cezası' WHEN 4 THEN
                       '4.Göz Altına Alınma' WHEN 5 THEN '5.Hükümlükle sonuçlanmayan tutukluluk hali' WHEN 6 THEN '6.Kısmi istihdam' WHEN 7 THEN '7.Grev' WHEN 8 THEN '8.Lokavt'
                       WHEN 9 THEN '9.Genel hayatı etkileyen olaylar' WHEN 10 THEN '10.Ekonomi' WHEN 11 THEN '11.Doğal Afetler' WHEN 12 THEN '12.İşe Giriş' WHEN 13 THEN '13.İşten Çıkış'
                       END AS EKSIK_CALISMA_NEDENI, pntcard.PERDINJURY AS DONEMDEKI_SAKATLIK_DERECESI, person.SSKNO AS SGKNO, person.INDATE AS ISEGIRIS_TARIHI, 
                      pntline.LREF
FROM         BORDRODB.dbo.LH_001_PNTCARD AS pntcard INNER JOIN
                      BORDRODB.dbo.LH_001_PNTLINE AS pntline ON pntcard.LREF = pntline.PREF INNER JOIN
                      BORDRODB.dbo.LH_001_PERSON AS person ON pntcard.PERREF = person.LREF LEFT OUTER JOIN                  
                      BORDRODB.dbo.LH_001_PAYELEM AS payelem ON pntline.TYP = payelem.TYP AND pntline.NR = payelem.NR LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PERFIN AS perfin ON person.LREF = perfin.PERREF LEFT OUTER JOIN
                      BORDRODB.dbo.L_CAPIFIRM AS capifirm ON capifirm.NR = person.FIRMNR LEFT OUTER JOIN
                      BORDRODB.dbo.L_CAPIUNIT AS capiunit ON capifirm.NR = capiunit.FIRMNR AND capiunit.NR = person.UNITNR
WHERE     (pntcard.PERDBEG = CONVERT(DATETIME, '2014-03-01', 102))");
            }

            if (!db.IsView("PUANTAJKARTI"))
            {
                db.CreateView("PUANTAJKARTI", @"SELECT     TOP (100) PERCENT person.CODE AS SICILNO, person.NAME AS ADI, person.SURNAME AS SOYADI, 
                      CASE person.FIRMNR WHEN 1 THEN '001 İSTANBUL OTOBÜS İŞLETMELERİ TİCARET A.Ş.' END AS KURUM, 
                      CASE person.DEPTNR WHEN 0 THEN '0000 GENEL MÜDÜRLÜK' WHEN 7 THEN '0007 YÖNETİM KURULU' END AS BOLUM, 
                      CASE person.LOCNR WHEN 0 THEN '0000 İSTANBUL OTOBÜS A.Ş.-MERKEZ' END AS IS_YERI, capiunit.NAME AS BIRIM, pntline.PERDBEG AS DONEM_BASI, 
                      pntline.LNNR AS SATIRNO, payelem.DEFINITION_ AS ACIKLAMA, pntline.TYP AS TURU, pntline.NR, pntline.DAY_ AS GUN, pntline.HOUR_ AS SAAT, 
                      pntline.COEFF AS KATSAYI, pntline.TRTYPE AS SATIR_TIPI, CASE pntline.CLCTYPE WHEN 1 THEN 'NET' WHEN 2 THEN 'BRÜT' END AS HESAPLAMA_SEKLI, 
                      CASE pntline.OPTYPE WHEN 1 THEN 'AY' WHEN 2 THEN 'GUN' WHEN 3 THEN 'SAAT' END AS ODEME_TIPI, 
                      CASE pntline.PAYABLE WHEN 0 THEN 'Ayni' WHEN 1 THEN 'Nakdi' END AS ODEME_SEKLI, pntline.AMNT AS BIRIM_TUTAR, 
                      CASE pntline.CURRTYPE WHEN 160 THEN 'TL' WHEN 1 THEN 'USD' END AS DOVIZ_TURU, pntline.GROSSAM AS TOPLAM_TUTAR, pntline.NETAM AS NET_TUTAR, 
                      pntline.BOSSAM, pntline.SIGN, pntline.TRDATE, pntcard.PERDEND, pntcard.BALN_WORKS_PTD AS MESAILER_TOPLAMI, 
                      CASE perfin.SSKSTATUS WHEN 1 THEN '4/a Normal' WHEN 2 THEN '4/a Emekli' WHEN 3 THEN '4/a Çyrak' WHEN 4 THEN '4/a Stajyer' WHEN 5 THEN '4/a Yabancı' WHEN
                       8 THEN 'Diğer' END AS SSKSTATUS, 
                      CASE PNTCARD.SSKMDAYREASON WHEN 0 THEN 'Yok' WHEN 1 THEN '1.HASTALIK' WHEN 2 THEN '2.Ücretsiz İzin' WHEN 3 THEN '3.Disiplin Cezası' WHEN 4 THEN
                       '4.Göz Altına Alınma' WHEN 5 THEN '5.Hükümlükle sonuçlanmayan tutukluluk hali' WHEN 6 THEN '6.Kısmi istihdam' WHEN 7 THEN '7.Grev' WHEN 8 THEN '8.Lokavt'
                       WHEN 9 THEN '9.Genel hayatı etkileyen olaylar' WHEN 10 THEN '10.Ekonomi' WHEN 11 THEN '11.Doğal Afetler' WHEN 12 THEN '12.İşe Giriş' WHEN 13 THEN '13.İşten Çıkış'
                       END AS EKSIK_CALISMA_NEDENI, pntcard.PERDINJURY AS DONEMDEKI_SAKATLIK_DERECESI, person.SSKNO AS SGKNO, person.INDATE AS ISEGIRIS_TARIHI, 
                      pntline.LREF
FROM         BORDRODB.dbo.LH_001_PNTCARD AS pntcard INNER JOIN
                      BORDRODB.dbo.LH_001_PNTLINE AS pntline ON pntcard.LREF = pntline.PREF INNER JOIN
                      BORDRODB.dbo.LH_001_PERSON AS person ON pntcard.PERREF = person.LREF LEFT OUTER JOIN                     
                      BORDRODB.dbo.LH_001_PAYELEM AS payelem ON pntline.TYP = payelem.TYP AND pntline.NR = payelem.NR LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PERFIN AS perfin ON person.LREF = perfin.PERREF LEFT OUTER JOIN
                      BORDRODB.dbo.L_CAPIFIRM AS capifirm ON capifirm.NR = person.FIRMNR LEFT OUTER JOIN
                      BORDRODB.dbo.L_CAPIUNIT AS capiunit ON capifirm.NR = capiunit.FIRMNR AND capiunit.NR = person.UNITNR
WHERE     (pntcard.PERDBEG = CONVERT(DATETIME, '2014-03-01', 102)) AND (pntline.LNNR = '1') ");
            }

            if (!db.IsView("vPersonelEkBilgiler"))
            {
                db.CreateView("vPersonelEkBilgiler", @"SELECT DISTINCT 
                      F.NAME AS KURUM, I.NAME AS ISYERI, B.NAME AS BOLUM, U.NAME AS BIRIM, P.CODE AS SICILNO, P.NAME AS ADI, P.SURNAME AS SOYADI, P.TITLE AS GOREVI, 
                      PERI.IDTCNO AS TCKIMLIK, P.SSKNO AS SGKNO, ADR.EXP1 AS ADRES, ILCE.EXP1 AS ILCE, ETL.EXP1 AS EVTEL, CTL1.EXP1 AS CEPTEL1, CTL2.EXP1 AS CEPTEL2, 
                      EMAIL.EXP1 AS EMAIL, PERI.DADDY AS BABAADI, PERI.MUMMY AS ANNEADI, CONVERT(VARCHAR(10), PERI.BIRTHDATE, 104) AS DOGUMTARIHI, 
                      PERI.BIRTHPLACE AS DOGUMYERI, 
                      CASE PERI.STATUS WHEN 0 THEN 'Belirtilmemiş' WHEN 1 THEN 'Evli' WHEN 2 THEN 'Bekar' WHEN 3 THEN 'Boşanmış' WHEN 4 THEN 'Dul' END AS MEDENIHAL, 
                      CASE PERI.BLOODGROUP WHEN 0 THEN 'Belirtilmemi?' WHEN 1 THEN '0RH+' WHEN 2 THEN '0RH-' WHEN 3 THEN 'ARH+' WHEN 4 THEN 'ARH-' WHEN 5 THEN 'BRH+'
                       WHEN 6 THEN 'BRH-' WHEN 7 THEN 'ABRH+' WHEN 8 THEN 'ABRH-' END AS KANGRUBU, 
                      CASE P.SEX WHEN 1 THEN 'Erkek' WHEN 2 THEN 'Kadın' END AS CINSIYET, 
                      CASE P.TYP WHEN 1 THEN 'Personel' WHEN 2 THEN 'Eski_Personel' END AS PERSTATUS, 
                      CASE PRF.SSKSTATUS WHEN 1 THEN '4/a Normal' WHEN 2 THEN '4/a Emekli' WHEN 3 THEN '4/a Çyrak' WHEN 4 THEN '4/a Stajyer' WHEN 5 THEN '4/a Yabancı' WHEN
                       8 THEN 'Diğer' END AS SSKSTATUS, P.LREF
FROM         BORDRODB.dbo.LH_001_PERSON AS P INNER JOIN
                      BORDRODB.dbo.LH_001_FAMILY AS FM ON P.LREF = FM.PERREF AND FM.RELATION = 0 INNER JOIN
                      BORDRODB.dbo.L_CAPIFIRM AS F ON F.NR = P.FIRMNR INNER JOIN
                      BORDRODB.dbo.L_CAPIDIV AS I ON F.NR = I.FIRMNR AND I.NR = P.LOCNR INNER JOIN
                      BORDRODB.dbo.L_CAPIDEPT AS B ON F.NR = B.FIRMNR AND B.NR = P.DEPTNR INNER JOIN
                      BORDRODB.dbo.L_CAPIUNIT AS U ON F.NR = U.FIRMNR AND U.NR = P.UNITNR LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PERIDINF AS PERI ON PERI.LREF = FM.LREF LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS ADR ON ADR.TYP = 1 AND ADR.CARDREF = FM.LREF LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS ILCE ON ILCE.TYP = - 1 AND ILCE.LNNR = 8 AND ILCE.CARDREF = FM.LREF LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS ETL ON ETL.TYP = 2 AND ETL.CARDREF = FM.LREF LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS CTL1 ON CTL1.TYP = 3 AND CTL1.LNNR = 1 AND CTL1.CARDREF = FM.LREF LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS CTL2 ON CTL2.TYP = 3 AND CTL2.LNNR = 2 AND CTL2.CARDREF = FM.LREF LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS EMAIL ON EMAIL.TYP = 6 AND EMAIL.CARDREF = FM.LREF LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PERFIN AS PRF ON PRF.PERREF = P.LREF");
            }

            if (!db.IsView("vPersoneller"))
            {
                db.CreateView("vPersoneller", @"SELECT TOP (100) PERCENT capf.NAME AS FIRMA, capidet.NAME AS DEPARTMAN, cdiv.NAME AS ISYERI, p.CODE AS SICILNO, p.NAME AS AD, p.SURNAME AS SOYAD, 
            CASE WHEN p.SEX = 1 THEN 'ERKEK' WHEN p.SEX = 2 THEN 'BAYAN' ELSE '' END AS CINSIYET, p.TITLE, p.SSKNO, p.TTFNO, p.PASSWORD, p.LREF, p.TYP, CAST(REPLACE(REPLACE(p.CODE, '-', ''), 'STJ', '99') 
            AS int) AS SiraNo
FROM   BORDRODB.dbo.LH_001_PERSON AS p WITH (NOLOCK, INDEX = I001_PERSON_I2) INNER JOIN
            BORDRODB.dbo.L_CAPIFIRM AS capf ON p.FIRMNR = capf.NR INNER JOIN
            BORDRODB.dbo.L_CAPIDEPT AS capidet ON p.DEPTNR = capidet.NR INNER JOIN
            BORDRODB.dbo.L_CAPIDIV AS cdiv ON p.LOCNR = cdiv.NR");
            }

            if (!db.IsView("vPersonelRapor"))
            {
                db.CreateView("vPersonelRapor", @"SELECT     fr.NAME AS FIRMA, dep.NAME AS DEPARTMAN, ism.NAME AS ISYERI, p.CODE AS SICILNO, p.NAME + '  ' + p.SURNAME AS ADSOYAD, 
                      CASE WHEN p.SEX = 1 THEN 'ERKEK' WHEN p.SEX = 2 THEN 'BAYAN' ELSE '' END AS CINSIYET, p.INDATE, p.TITLE, p.SSKNO, p.TTFNO, p.PASSWORD, p.LREF, 
                      f.LDATA, p.FIRMNR, ab.DADDY, ab.MUMMY, ab.BIRTHPLACE, ab.BIRTHDATE, ab.IDTCNO, ab.SERIALNO, ab.NO_, ab.CITY, ab.TOWN, ab.VILLAGE, ab.GIVENPLACE, 
                      ab.GIVENREASON, ab.PAGE, ab.BOOK, ab.ROW_, ab.GIVENDATE, ab.EXSURNAME, ab.NATIONALITY, ab.MILTSTATUS,
                          (SELECT     COUNT(SEX) AS Expr1
                            FROM          BORDRODB.dbo.LH_001_FAMILY WITH (NOLOCK, INDEX = I001_FAMILY_I1)
                            WHERE      (RELATION = 2) AND (SEX = 1) AND (PERREF = p.LREF)) AS ERKEKCOCUK,
                          (SELECT     COUNT(SEX) AS Expr1
                            FROM          BORDRODB.dbo.LH_001_FAMILY AS LH_001_FAMILY_1 WITH (NOLOCK, INDEX = I001_FAMILY_I1)
                            WHERE      (RELATION = 2) AND (SEX = 2) AND (PERREF = p.LREF)) AS KIZCOCUK, '' AS MEDENIHAL, tel.EXP1 AS TEL, cep.EXP1 AS CEPTEL, 
                      email.EXP1 AS [E-Posta], '' AS KanGrubu, adres.EXP1 + '' + adres.EXP2 AS ADRES, is1.WORK_ + ' ' + is1.FIRM AS Is1, is2.WORK_ + ' ' + is2.FIRM AS Is2, 
                      is3.WORK_ + ' ' + is3.FIRM AS Is3, isht.LOGREF, isht.PARLOGREF, isht.DoktoraKonusu, isht.Ihtisas, isht.Universite, isht.Lisa, isht.YabDil, isht.Ref1, isht.Ref2, 
                      isht.Ref3, isht.BitOOkul, isht.BitIlk, isht.BitLise, isht.BitUni, isht.BitYuksekLisans, isht.MezunOld, isht.MBolum, isht.SonOkul, isht.Istirak, isht.PerStatu
FROM         BORDRODB.dbo.LH_001_PERIDINF AS ab WITH (NOLOCK, INDEX = I001_PERIDINF_I1) INNER JOIN
                      BORDRODB.dbo.LH_001_FAMILY AS f WITH (NOLOCK, INDEX = I001_FAMILY_I1) ON ab.LREF = f.LREF RIGHT OUTER JOIN
                      BORDRODB.dbo.LH_001_PERSON AS p WITH (NOLOCK, INDEX = I001_PERSON_I2) INNER JOIN
                      BORDRODB.dbo.L_CAPIFIRM AS fr ON p.FIRMNR = fr.NR INNER JOIN
                      BORDRODB.dbo.L_CAPIDEPT AS dep ON p.DEPTNR = dep.NR INNER JOIN
                      BORDRODB.dbo.L_CAPIDIV AS ism ON p.LOCNR = ism.NR ON f.LREF = p.LREF LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS adres WITH (NOLOCK, INDEX = I001_CONTACT_I1) ON adres.CARDREF = f.LREF AND adres.TYP = 1 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS tel WITH (NOLOCK, INDEX = I001_CONTACT_I1) ON tel.CARDREF = f.LREF AND tel.TYP = 2 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS cep WITH (NOLOCK, INDEX = I001_CONTACT_I1) ON cep.CARDREF = f.LREF AND cep.TYP = 3 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS email WITH (NOLOCK, INDEX = I001_CONTACT_I1) ON email.CARDREF = f.LREF AND email.TYP = 6 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PEREXPR AS is1 WITH (NOLOCK, INDEX = I001_PEREXPR_I1) ON is1.PERREF = p.LREF AND is1.LNNR = 1 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PEREXPR AS is2 WITH (NOLOCK, INDEX = I001_PEREXPR_I1) ON is2.PERREF = p.LREF AND is2.LNNR = 2 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PEREXPR AS is3 WITH (NOLOCK, INDEX = I001_PEREXPR_I1) ON is3.PERREF = p.LREF AND is3.LNNR = 3 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_XT1020_001 AS isht WITH (NOLOCK, INDEX = XT1020_001_XTIND2) ON isht.PARLOGREF = p.LREF");
            }

            if (!db.IsView("vPersRapor"))
            {
                db.CreateView("vPersRapor", @"SELECT     fr.NAME AS FIRMA, dep.NAME AS DEPARTMAN, ism.NAME AS ISYERI, p.CODE AS SICILNO, p.NAME + '  ' + p.SURNAME AS ADSOYAD, 
                      CASE WHEN p.SEX = 1 THEN 'Erkek' WHEN p.SEX = 2 THEN 'Bayan' ELSE '' END AS CINSIYET, p.INDATE, p.RIGHTSBEGDATE, un.NAME AS TITLE1,
                          (SELECT     TOP (1) TITLE
                            FROM          BORDRODB.dbo.LH_001_ASSIGN
                            WHERE      (PERREF = p.LREF)
                            ORDER BY LREF DESC) AS TITLE, p.SSKNO, p.TTFNO, p.PASSWORD, p.LREF, f.LDATA, p.FIRMNR, ab.DADDY, ab.MUMMY, ab.BIRTHPLACE, ab.BIRTHDATE, 
                      ab.IDTCNO, ab.SERIALNO, ab.NO_, ab.CITY, ab.TOWN, ab.VILLAGE, ab.GIVENPLACE, ab.GIVENREASON, ab.PAGE, ab.BOOK, ab.ROW_, ab.GIVENDATE, 
                      ab.EXSURNAME, ab.NATIONALITY, ab.MILTSTATUS,
                          (SELECT     CASE WHEN COUNT(SEX) = 0 THEN '( )' ELSE '( ' + CAST(COUNT(SEX) AS nvarchar) + ' )' END AS Expr1
                            FROM          BORDRODB.dbo.LH_001_FAMILY WITH (NOLOCK, INDEX = I001_FAMILY_I1)
                            WHERE      (RELATION = 2) AND (SEX = 1) AND (PERREF = p.LREF)) AS ERKEKCOCUK,
                          (SELECT     CASE WHEN COUNT(SEX) = 0 THEN '( )' ELSE '(' + CAST(COUNT(SEX) AS nvarchar) + ')' END AS Expr1
                            FROM          BORDRODB.dbo.LH_001_FAMILY AS LH_001_FAMILY_1 WITH (NOLOCK, INDEX = I001_FAMILY_I1)
                            WHERE      (RELATION = 2) AND (SEX = 2) AND (PERREF = p.LREF)) AS KIZCOCUK, 
                      CASE WHEN p.[STATUS] = 1 THEN 'Evli' WHEN p.[STATUS] = 2 THEN 'Bekar' ELSE 'Belirtilmemiş' END AS MEDENIHAL, tel.EXP1 AS TEL, cep.EXP1 AS CEPTEL, 
                      email.EXP1 AS [E-Posta], 
                      CASE WHEN ab.BLOODGROUP = 1 THEN 'O Rh + ' WHEN ab.BLOODGROUP = 2 THEN 'O Rh - ' WHEN ab.BLOODGROUP = 3 THEN 'A Rh + ' WHEN ab.BLOODGROUP =
                       4 THEN 'A Rh - ' WHEN ab.BLOODGROUP = 5 THEN 'B Rh + ' WHEN ab.BLOODGROUP = 6 THEN 'B Rh - ' WHEN ab.BLOODGROUP = 7 THEN 'AB Rh + ' WHEN ab.BLOODGROUP
                       = 8 THEN 'AB Rh - ' ELSE '' END AS KanGrubu, adres.EXP1 + '' + adres.EXP2 AS ADRES, is1.WORK_ + ' ' + is1.FIRM AS Is1, is2.WORK_ + ' ' + is2.FIRM AS Is2, 
                      is3.WORK_ + ' ' + is3.FIRM AS Is3, isht.LOGREF, isht.PARLOGREF, isht.DoktoraKonusu, isht.Ihtisas, isht.Universite, isht.Lisa, isht.YabDil, isht.Ref1, isht.Ref2, 
                      isht.Ref3, isht.BitOOkul, isht.BitIlk, isht.BitLise, isht.BitUni, isht.BitYuksekLisans, isht.MezunOld, isht.MBolum, isht.SonOkul, isht.Istirak, isht.PerStatu
FROM         BORDRODB.dbo.LH_001_PERSON AS p WITH (NOLOCK, INDEX = I001_PERSON_I2) INNER JOIN
                      BORDRODB.dbo.L_CAPIFIRM AS fr ON p.FIRMNR = fr.NR INNER JOIN
                      BORDRODB.dbo.L_CAPIDEPT AS dep ON p.DEPTNR = dep.NR INNER JOIN
                      BORDRODB.dbo.L_CAPIUNIT AS un ON p.UNITNR = un.NR INNER JOIN
                      BORDRODB.dbo.L_CAPIDIV AS ism ON p.LOCNR = ism.NR LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_FAMILY AS f WITH (NOLOCK, INDEX = I001_FAMILY_I1) ON f.PERREF = p.LREF AND f.RELATION = 0 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PERIDINF AS ab WITH (NOLOCK, INDEX = I001_PERIDINF_I1) ON ab.LREF = f.LREF LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS adres WITH (NOLOCK, INDEX = I001_CONTACT_I1) ON adres.CARDREF = f.LREF AND adres.TYP = 1 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS tel WITH (NOLOCK, INDEX = I001_CONTACT_I1) ON tel.CARDREF = f.LREF AND tel.TYP = 2 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS cep WITH (NOLOCK, INDEX = I001_CONTACT_I1) ON cep.CARDREF = f.LREF AND cep.TYP = 3 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_CONTACT AS email WITH (NOLOCK, INDEX = I001_CONTACT_I1) ON email.CARDREF = f.LREF AND email.TYP = 6 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PEREXPR AS is1 WITH (NOLOCK, INDEX = I001_PEREXPR_I1) ON is1.PERREF = p.LREF AND is1.LNNR = 1 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PEREXPR AS is2 WITH (NOLOCK, INDEX = I001_PEREXPR_I1) ON is2.PERREF = p.LREF AND is2.LNNR = 2 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_001_PEREXPR AS is3 WITH (NOLOCK, INDEX = I001_PEREXPR_I1) ON is3.PERREF = p.LREF AND is3.LNNR = 3 LEFT OUTER JOIN
                      BORDRODB.dbo.LH_XT1020_001 AS isht WITH (NOLOCK, INDEX = XT1020_001_XTIND2) ON isht.PARLOGREF = p.LREF");
            }

   
            
        }


        public static DevExpress.Xpo.Session Crs
        {
            get
            {
                if (_session == null)
                    Connect(ConfigurationManager.ConnectionStrings["CONSTR"].ConnectionString);

                return _session;
            }
        }


    }

}
