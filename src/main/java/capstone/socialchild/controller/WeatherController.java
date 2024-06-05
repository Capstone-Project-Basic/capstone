package capstone.socialchild.controller;

import capstone.socialchild.domain.weather.SunRiseSet;
import capstone.socialchild.domain.weather.Weather;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/weather")
public class WeatherController {

    @RequestMapping
    public Weather showWeather(){
        Weather nowWeather = new Weather();
        nowWeather.setDate(nowWeather.date()); //날짜
        nowWeather.setHour(nowWeather.hour()); //시간
        nowWeather.setWeather(nowWeather.weather()); //날씨
        nowWeather.setTemperature(nowWeather.temperature()); //기온
        nowWeather.setHumidity(nowWeather.humidity()); //습도
        return nowWeather;
    }

    @RequestMapping("/sunRiseSet")
    public SunRiseSet showSunRiseSet(){
        SunRiseSet nowSunRiseSet = new SunRiseSet();
        nowSunRiseSet.setSunDate(nowSunRiseSet.sunDate()); //날짜
        nowSunRiseSet.setSunRise(nowSunRiseSet.sunRise()); //일출시간
        nowSunRiseSet.setSunSet(nowSunRiseSet.sunSet()); //일몰시간
        return nowSunRiseSet;
    }
}
