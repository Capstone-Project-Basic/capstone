package capstone.socialchild.controller;

import capstone.socialchild.dto.member.request.UpdateLocation;
import capstone.socialchild.service.LocationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@Slf4j
@RestController
@RequiredArgsConstructor
public class LocationController {

    private final LocationService locationService;

    /**
     * 위치좌표 수정
     */
    @PatchMapping("/members/{memberId}/location")
    public boolean updateLocation(@PathVariable("memberId") Long memberId, @RequestBody UpdateLocation request) {
        log.info("Updating location for memberId: {}, Latitude: {}, Longitude: {}", memberId, request.getLatitude(), request.getLongitude());
        return locationService.updateMemberLocation(memberId, request);
    }
}
