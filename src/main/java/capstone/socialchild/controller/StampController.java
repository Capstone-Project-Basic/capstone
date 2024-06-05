package capstone.socialchild.controller;

import capstone.socialchild.dto.mission.MissionResponseDto;
import capstone.socialchild.dto.stamp.StampRequestDto;
import capstone.socialchild.dto.stamp.StampResponseDto;
import capstone.socialchild.service.StampService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
public class StampController {

    @Autowired
    StampService stampService;

    @GetMapping("/{memberId}/stamps")
    public List<StampResponseDto> findStampAll (@PathVariable("memberId") Long memberId) {
        return stampService.showAll(memberId);
    }

    @GetMapping("/{memberId}/stamps/{id}")
    public StampResponseDto findStampOne (@PathVariable("id") Long id) {
        return stampService.showOne(id);
    }


    @GetMapping("/{memberId}/stamps/{id}/mission")
    public MissionResponseDto findMissionContents (@PathVariable("id") Long id) {
        return stampService.showMission(id);
    }

    @PostMapping("/{memberId}/stamps")
    public StampResponseDto newStamp(@PathVariable("memberId") Long memberId,
                                     @RequestBody StampRequestDto requestDto) {
        return stampService.create(memberId, requestDto);
    }
}
