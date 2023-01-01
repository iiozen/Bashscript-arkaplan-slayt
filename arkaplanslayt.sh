#!/bin/bash
VRSN="1.0"
VERSION="MASAUSTU ARKA PLAN SLAYT BASHSCRIPT ==> v$VRSN"
DIR=`pwd`
GPATH=
CPATH=
GOSTERIMSURE=600
GECISSURE=0


gsettings set org.gnome.desktop.background picture-uri-dark "/usr/share/backgrounds/contest/kinetic.xml"
gsettings set org.gnome.desktop.background picture-uri "/usr/share/backgrounds/contest/kinetic.xml"

# RELATIVE ve ABSOLUTE AYRIMI
path_duzenler() {
            cpth=
            if [ ${1:0:1} == "/" ]
            then
                cpth=$1
            else
                cpth=$DIR/$1
            fi
            echo "$cpth"
}





while [ -n $1 ];
do
    case $1 in
        -g | --giris)
            shift
            if [ -z $1 ]
            then
            echo "dosya yolu girilmedi">&2
            exit 2
            fi
            GPATH="$(path_duzenler $1)"
            
        ;;

        -c | --cikis)
            shift
            if [ -z $1 ]
            then
            echo "dosya yolu girilmedi">&2
            exit 2
            fi
            CPATH="$(path_duzenler $1)"
            
        ;;
        -t | --gosterimsure)
            shift
            if [ -z $1 ]
            then
            echo "-t | --gosterimsure hatası."
            echo "Fotoğraf başına gösterilecek süre girilmedi."
            echo "Varsayılan değer: 600">&2
            exit 2
            elif [ 0 ]
            then
            [ "$1" -eq "$1" ] 2>/dev/null
            if [ $? -ne 0 ]
            then
            echo "-t | --gosterimsure hatası."
            echo "Fotoğraf başına gösterilecek süre sayısal değer olarak girilmelidir."
            echo "Varsayılan değer: 600">&2
            exit 2
            fi
            fi
            GOSTERIMSURE=$1            
        ;;

        -k | --gecissure)
            shift
            if [ -z $1 ]
            then
            echo "-k | --gecissure hatası."
            echo "Fotoğraflar arası geçiş süresi girilmedi."
            echo "Varsayılan değer: 0">&2
            exit 2
            elif [ 0 ]
            then
            [ "$1" -eq "$1" ] 2>/dev/null
            if [ $? -ne 0 ]
            then
            echo "-k | --gecissure hatası."
            echo "Fotoğraflar arası geçiş süresi sayısal değer olarak girilmelidir."
            echo "Varsayılan değer: 0">&2
            exit 2
            fi
            fi
            GECISSURE=$1
        ;;

        -v | --version)
            echo "$VERSION"
            exit 0

        ;;


        -h | --help)
            echo " İhtiyaç duyulan tüm dizin yollarını relative veya absolute girebilirsiniz."
            echo " -g | --giris bu komut fotoğrafların bulunduğu klasör dizin yoluna ihtiyaç duyar."
            echo " -c | --cikis bu komut CPATH olacak fotoğrafların bulunacağı dizin yoluna ihtiyaç duyar."
            echo " -t | --gosterimsure bu komut fotoğraf başına gösterilecek süreyi belirlemek için kullanılır."
            echo " -k | --gecissure bu komut fotoğraflar arası geçiş süresini belirlemek için kullanılır."
            echo " -v | --version versiyon sayısını verir."    

        ;;
        *)
            echo "Geçersiz seçenek: $1"
            echo "Kullanım için -h veya --help yazınız."
        exit
        ;;
    esac
shift

if [ -z $1 ]
then
break
fi

done


if [ "${CPATH: -1}" == "/" ]
then
CPATH="${CPATH:0:-1}"
fi

if [ "${GPATH: -1}" == "/" ]
then
GPATH="${GPATH:0:-1}"
fi



if [ -f "/usr/share/backgrounds/contest/backgrounds.xml" ]
then
sudo rm /usr/share/backgrounds/contest/backgrounds.xml
fi
((foto=0))

if [ -d "${CPATH}/" ]
then
rm -rf ${CPATH}/
fi
mkdir ${CPATH}

for i in ${GPATH}/*
do
((foto++))
cp "${i}" "${CPATH}/${foto}.${i##*.}"
done
echo "${foto} adet fotoğraf hazırlandı"

echo "<background>" > backgrounds.xml
echo "  <starttime>" >> backgrounds.xml
echo "      <year>2009</year>" >> backgrounds.xml
echo "      <month>08</month>" >> backgrounds.xml
echo "      <day>04</day>" >> backgrounds.xml
echo "      <hour>00</hour>" >> backgrounds.xml
echo "      <minute>00</minute>" >> backgrounds.xml
echo "      <second>00</second>" >> backgrounds.xml
echo "  </starttime>" >> backgrounds.xml

((dosyasayisi=1))
ilkyer=a
oncekiyer=a
((fotosayisi=0))
for i in ${CPATH}/*
do
((fotosayisi=$fotosayisi+1))
done
for i in ${CPATH}/*
do
if [ $dosyasayisi -gt 1 ]
then
echo "<static>" >> backgrounds.xml
echo "  <duration>${GOSTERIMSURE}</duration>">> backgrounds.xml
echo "  <file>${oncekiyer}</file>" >> backgrounds.xml
echo "</static>" >> backgrounds.xml
echo "<transition>" >> backgrounds.xml
echo "  <duration>${GECISSURE}</duration>" >> backgrounds.xml
echo "  <from>${oncekiyer}</from>" >> backgrounds.xml
echo "  <to>${i}</to>" >> backgrounds.xml
echo "</transition>" >> backgrounds.xml

else
ilkyer=$i
fi
((dosyasayisi=${dosyasayisi}+1))
oncekiyer=$i
done

echo "  <static>" >> backgrounds.xml
echo "      <duration>${GOSTERIMSURE}</duration>">> backgrounds.xml
echo "      <file>${i}</file>" >> backgrounds.xml
echo "  </static>" >> backgrounds.xml
echo "  <transition>" >> backgrounds.xml
echo "      <duration>${GECISSURE}</duration>" >> backgrounds.xml
echo "      <from>${i}</from>" >> backgrounds.xml
echo "      <to>${ilkyer}</to>" >> backgrounds.xml
echo "  </transition>" >> backgrounds.xml

echo "<background>" >> backgrounds.xml

sudo cp $DIR/backgrounds.xml /usr/share/backgrounds/contest/
rm backgrounds.xml


gsettings set org.gnome.desktop.background picture-uri-dark "/usr/share/backgrounds/contest/backgrounds.xml"
gsettings set org.gnome.desktop.background picture-uri "/usr/share/backgrounds/contest/backgrounds.xml"
