package capstone.socialchild.service;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.mission.Mission;
import capstone.socialchild.domain.mission.SuccessMission;
import capstone.socialchild.domain.stamp.Stamp;
import capstone.socialchild.dto.mission.MissionResponseDto;
import capstone.socialchild.dto.stamp.StampRequestDto;
import capstone.socialchild.dto.stamp.StampResponseDto;
import capstone.socialchild.repository.MemberRepository;
import capstone.socialchild.repository.MissionRepository;
import capstone.socialchild.repository.StampRepository;
import capstone.socialchild.repository.SuccessMissionRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Slf4j
@Service
public class StampService {

    @Autowired
    StampRepository stampRepository;

    @Autowired
    MemberRepository memberRepository;

    @Autowired
    SuccessMissionRepository successMissionRepository;

    @Autowired
    MissionRepository missionRepository;

    public List<StampResponseDto> showAll(Long memberId) {
        return stampRepository.findByStamp(memberId)
                .stream()
                .map(StampResponseDto::new)
                .collect(Collectors.toList());
    }

    public StampResponseDto showOne(Long stampId) {
        Stamp stamp = stampRepository.findById(stampId).orElseThrow(() -> new IllegalArgumentException("해당 도장이 없습니다. id=" + stampId));
        return new StampResponseDto(stamp);

    }

    // 도장 클릭시 미션 상세내용 보기
    public MissionResponseDto showMission(Long stampId) {
        log.info("stampid :" + stampId);
        Stamp stamp = stampRepository.findById(stampId)
                .orElseThrow(() -> new IllegalArgumentException("해당 도장이 없습니다. id=" + stampId));
        Mission mission = stamp.getSuccessMission().getMission();

        return new MissionResponseDto(mission);
    }

    public StampResponseDto create(Long memberId, StampRequestDto requestDto) {
        if (memberId == null)
            throw new IllegalArgumentException("현재 유저가 없습니다.");
        Member member = memberRepository.findOne(requestDto.getMemberId());
        SuccessMission successMission = successMissionRepository.findById(requestDto.getSuccessMissionId())
                .orElseThrow(() -> new IllegalArgumentException("해당 미션이 없습니다. id=" + requestDto.getSuccessMissionId()));

        Stamp stamp = Stamp.builder()
                .member(member)
                .successMission(successMission)
                .build();
        stampRepository.save(stamp);
        return new StampResponseDto(stamp);
    }

}
