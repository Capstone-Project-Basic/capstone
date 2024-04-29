package capstone.socialchild.domain.weather;

import lombok.Getter;
import lombok.Setter;
import org.springframework.stereotype.Component;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import javax.xml.parsers.DocumentBuilderFactory;
import java.net.HttpURLConnection;
import java.net.URL;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Component
@Getter
@Setter
public class SunRiseSet {
    private String sunDate; //날짜
    private String sunRise; //일출시간
    private String sunSet; //일몰시간

    public String sunDate(){
        String[] k = new String[3];
        String[] h = get(k);
        return h[0];
    }
    public String sunRise(){
        String[] k = new String[3];
        String[] h = get(k);
        return h[1];
    }
    public String sunSet(){
        String[] k = new String[3];
        String[] h = get(k);
        return h[2];
    }


    //v[0]: 날짜 , v[1]: 일출시간 , v[2]: 일몰시간
    public static String[] get(String[] v) {
        HttpURLConnection con = null;
        String s = null; // 에러 메시지

        try {
            LocalDateTime t = LocalDateTime.now(); // 현재 시각

            URL url = new URL(
                    "http://apis.data.go.kr/B090041/openapi/service/RiseSetInfoService/getAreaRiseSetInfo"
                            + "?location=%EC%88%98" + "%EC%9B%90" // location:수원
                            + "&locdate=" + t.format(DateTimeFormatter.ofPattern("yyyyMMdd"))  // 날짜
                            + "&ServiceKey=DwhVzR%2FiMRPtkArueDoXs7qIkuG6rRy66mtCllWzaPYcBv%2BzocFsTYdeawg9jdmbHG%2BEan5TC1zKvLkhbMmjUQ%3D%3D" // 서비스키
            );

            con = (HttpURLConnection) url.openConnection();
            Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(con.getInputStream());

            boolean ok = false; // <resultCode>00</resultCode> 획득 여부

            Element e;
            NodeList ns = doc.getElementsByTagName("header");
            if (ns.getLength() > 0) {
                e = (Element) ns.item(0);
                if ("00".equals(e.getElementsByTagName("resultCode").item(0).getTextContent()))
                    ok = true; // 성공 여부
                else // 에러 메시지
                    s = e.getElementsByTagName("resultMsg").item(0).getTextContent();
            }

            if (ok) {
                String sunrise = null, sunset = null; //일출 , 일몰
                String sundate = null; //날짜

                ns = doc.getElementsByTagName("item");
                for (int i = 0; i < ns.getLength(); i++) {
                    e = (Element) ns.item(i);
                    sundate = e.getElementsByTagName("locdate").item(0).getTextContent(); //날짜 가져오기
                    sunrise = e.getElementsByTagName("sunrise").item(0).getTextContent(); //일출 시간 가져오기
                    sunset = e.getElementsByTagName("sunset").item(0).getTextContent(); //일몰 시간 가져오기
                }

                v[0] = sundate;
                v[1] = sunrise;
                v[2] = sunset;

            }
        } catch (Exception e) {
            s = e.getMessage();
        }

        if (con != null)
            con.disconnect();
        return v;

    }
}
