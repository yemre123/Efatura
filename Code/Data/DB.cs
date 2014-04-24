using System;
using DevExpress.Xpo;
using System.Linq;


namespace Data
{


    [Persistent(@"vPersoneller")]
    public class vPersoneller : XPLiteObject
    {
        public string FIRMA { get; set; }
        public string DEPARTMAN { get; set; }
        public string ISYERI { get; set; }
        public string SICILNO { get; set; }
        public string AD { get; set; }
        public string SOYAD { get; set; }
        public string CINSIYET { get; set; }
        public string TITLE { get; set; }
        public string SSKNO { get; set; }
        public string TTFNO { get; set; }
        public string PASSWORD { get; set; }
        [Key]
        public int LREF { get; set; }

        public short TYP { get; set; }

        public int SiraNo { get; set; }


        [NonPersistent]
        public vPersonelEkBilgiler EkBilgiler
        {
            get
            {
                return XP.Crs.GetObjectByKey<vPersonelEkBilgiler>(LREF);
            }
            set
            {
                object Obj = value;
            }
        }

        public vPersoneller(Session session) : base(session) { }
        public vPersoneller() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }


    [Persistent(@"PersonalBelgeler")]
    public class PersonalBelgeler : XPObject
    {
        public string BELGE_TURU { get; set; }
        public string SICIL_NUMARASI { get; set; }
        public string FIRMA { get; set; }
        public string PERSONAL_NUMARASI { get; set; }
        public int PERSONAL_ID { get; set; }
        public int LREF { get; set; }
        public string AD { get; set; }
        public string SOYAD { get; set; }

        public string FileName { get; set; }
        [Size(255)]
        public string FileFullName { get; set; }

        public DateTime TARIH { get; set; }
        public int USERID { get; set; }

        public byte[] FILE { get; set; }

        public PersonalBelgeler(Session session) : base(session) { }
        public PersonalBelgeler() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }


    [Persistent(@"vPersonelEkBilgiler")]
    public class vPersonelEkBilgiler : XPLiteObject
    {
        public string KURUM { get; set; }
        public string ISYERI { get; set; }
        public string BOLUM { get; set; }
        public string BIRIM { get; set; }
        public string SICILNO { get; set; }
        public string ADI { get; set; }
        public string SOYADI { get; set; }
        public string GOREVI { get; set; }
        public string TCKIMLIK { get; set; }
        public string SGKNO { get; set; }
        public string ADRES { get; set; }
        public string ILCE { get; set; }
        public string EVTEL { get; set; }
        public string CEPTEL1 { get; set; }
        public string CEPTEL2 { get; set; }
        public string EMAIL { get; set; }
        public string BABAADI { get; set; }
        public string ANNEADI { get; set; }
        public string DOGUMTARIHI { get; set; }
        public string DOGUMYERI { get; set; }
        public string MEDENIHAL { get; set; }
        public string KANGRUBU { get; set; }
        public string CINSIYET { get; set; }
        public string PERSTATUS { get; set; }
        public string SSKSTATUS { get; set; }
        [Key]
        public int LREF { get; set; }


        public vPersonelEkBilgiler(Session session) : base(session) { }
        public vPersonelEkBilgiler() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }


    public class CFG : XPObject
    {
        public string HOST { get; set; }
        public string USER { get; set; }
        public string PWD { get; set; }

        public string GIBVergiKod1 { get; set; }
        [Size(255)]
        public string GIBVergiAd1 { get; set; }

        public string EPostaAdres { get; set; }
        public string EPostaPwd { get; set; }

        public string EPOSTHOST { get; set; }
        public int EPOSTPORT { get; set; }

        public CFG(Session session) : base(session) { }
        public CFG() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }


        static CFG xcfg = null;
        [NonPersistent]
        public static Data.CFG Cfg
        {
            get
            {
                if (xcfg == null)
                    xcfg = new XPCollection<Data.CFG>(XP.Crs).First();

                return xcfg;
            }
        }
    }

    public class TANIMLAR : XPObject
    {
        public string TIPAD { get; set; }
        public int TIP { get; set; }

        [Size(255)]
        public string EXP1 { get; set; }
        [Size(255)]
        public string EXP2 { get; set; }


        public TANIMLAR(Session session) : base(session) { }
        public TANIMLAR() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }

    }

    [Persistent(@"IZINLER")]
    public class IZINLER : XPLiteObject
    {

        public string CODE { get; set; }
        public string NAME { get; set; }
        public string SURNAME { get; set; }
        public string YIL { get; set; }
        public string HAKEDILEN_IZIN { get; set; }
        public string KULLANILAN_IZIN { get; set; }
        public string DEVREDEN { get; set; }
        public string KULLANILMIS_IZIN { get; set; }
        public string BAKIYE { get; set; }



        [Key]
        public int LREF { get; set; }


        public IZINLER(Session session) : base(session) { }
        public IZINLER() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }

    [Persistent(@"BORCLAR")]
    public class BORCLAR : XPLiteObject
    {

        public DateTime TARIH { get; set; }
        public string SICILNO { get; set; }
        public string NAME { get; set; }
        public string SURNAME { get; set; }
        public string KURUM { get; set; }
        public string BOLUM { get; set; }
        public string IS_YERI { get; set; }
        public string BORC_KODU { get; set; }
        public string BORC_TANIMI { get; set; }
        public string BORC_TUTARI { get; set; }
        public string DOVIZ_TURU { get; set; }
        public string ISLEM_TURU { get; set; }
        public string ODEME_SEKLI { get; set; }
        public string TAKSIT_SAYISI { get; set; }
        public DateTime ODEME_TARIHI { get; set; }
        public string TAKSIT_TUTARI { get; set; }


        [Key]
        public int LREF { get; set; }


        public BORCLAR(Session session) : base(session) { }
        public BORCLAR() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }

    [Persistent(@"PUANTAJKARTI")]
    public class PUANTAJKARTI : XPLiteObject
    {

        public string SICILNO { get; set; }
        public string ADI { get; set; }
        public string SOYADI { get; set; }
        public string KURUM { get; set; }
        public string BOLUM { get; set; }
        public string IS_YERI { get; set; }
        public string BIRIM { get; set; }
        public DateTime DONEM_BASI { get; set; }
        public string SATIRNO { get; set; }
        public string ACIKLAMA { get; set; }
        public string TURU { get; set; }
        public string NR { get; set; }
        public string GUN { get; set; }
        public string SAAT { get; set; }
        public string KATSAYI { get; set; }
        public string SATIR_TIPI { get; set; }
        public string HESAPLAMA_SEKLI { get; set; }
        public string ODEME_TIPI { get; set; }
        public string ODEME_SEKLI { get; set; }
        public string BIRIM_TUTAR { get; set; }
        public string DOVIZ_TURU { get; set; }
        public string TOPLAM_TUTAR { get; set; }
        public string NET_TUTAR { get; set; }
        public string BOSSAM { get; set; }
        public string SIGN { get; set; }
        public DateTime TRDATE { get; set; }
        public DateTime PERDEND { get; set; }
        public string MESAILER_TOPLAMI { get; set; }
        public string SSKSTATUS { get; set; }
        public string EKSIK_CALISMA_NEDENI { get; set; }
        public string DONEMDEKI_SAKATLIK_DERECESI { get; set; }
        public string SGKNO { get; set; }
        public DateTime ISEGIRIS_TARIHI { get; set; }







        [Key]
        public int LREF { get; set; }


        public PUANTAJKARTI(Session session) : base(session) { }
        public PUANTAJKARTI() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }

    [Persistent(@"PUANTAJKARTDETAY")]
    public class PUANTAJKARTDETAY : XPLiteObject
    {

        public string SICILNO { get; set; }
        public string ADI { get; set; }
        public string SOYADI { get; set; }
        public string KURUM { get; set; }
        public string BOLUM { get; set; }
        public string IS_YERI { get; set; }
        public string BIRIM { get; set; }
        public DateTime DONEM_BASI { get; set; }
        public string SATIRNO { get; set; }
        public string ACIKLAMA { get; set; }
        public string TURU { get; set; }
        public string NR { get; set; }
        public string GUN { get; set; }
        public string SAAT { get; set; }
        public string KATSAYI { get; set; }
        public string SATIR_TIPI { get; set; }
        public string HESAPLAMA_SEKLI { get; set; }
        public string ODEME_TIPI { get; set; }
        public string ODEME_SEKLI { get; set; }
        public string BIRIM_TUTAR { get; set; }
        public string DOVIZ_TURU { get; set; }
        public string TOPLAM_TUTAR { get; set; }
        public string NET_TUTAR { get; set; }
        public string ISVEREN_PAYI { get; set; }
        public string SIGN { get; set; }
        public string DUZENLEME_TABANI { get; set; }
        public string NAKIT_KISMI { get; set; }
        public DateTime ISLEM_TARIHI { get; set; }
        public string VERGI_ISTISNA_TUTARI { get; set; }
        public DateTime PERDEND { get; set; }
        public string MESAILER_TOPLAMI { get; set; }
        public string SSKSTATUS { get; set; }
        public string EKSIK_CALISMA_NEDENI { get; set; }
        public string DONEMDEKI_SAKATLIK_DERECESI { get; set; }
        public string SGKNO { get; set; }
        public DateTime ISEGIRIS_TARIHI { get; set; }





        [Key]
        public int LREF { get; set; }


        public PUANTAJKARTDETAY(Session session) : base(session) { }
        public PUANTAJKARTDETAY() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }

    [Persistent(@"IZINTANIM")]
    public class IZINTANIM : XPLiteObject
    {

        public string Expr1 { get; set; }
        public string EXP { get; set; }
        public string Expr2 { get; set; }
        public string Expr3 { get; set; }
        public string PERIOD { get; set; }
        public string DURUM { get; set; }



        public string CODE { get; set; }
        [Key]
        public int LREF { get; set; }


        public IZINTANIM(Session session) : base(session) { }
        public IZINTANIM() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }

    [Persistent(@"BORCTANIMLARI")]
    public class BORCTANIMLARI : XPLiteObject
    {

        public string CODE { get; set; }
        public string DEFINITION_ { get; set; }
        [Key]
        public int LREF { get; set; }


        public BORCTANIMLARI(Session session) : base(session) { }
        public BORCTANIMLARI() : base(Session.DefaultSession) { }
        public override void AfterConstruction() { base.AfterConstruction(); }
    }



}
