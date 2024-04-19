package capstone.socialchild.service;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.mission.SuccessMission;
import capstone.socialchild.domain.stamp.Stamp;
import capstone.socialchild.dto.stamp.StampRequestDto;
import capstone.socialchild.dto.stamp.StampResponseDto;
import capstone.socialchild.repository.MemberRepository;
import capstone.socialchild.repository.StampRepository;
import capstone.socialchild.repository.SuccessMissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class StampService {

    @Autowired
    StampRepository stampRepository;

    @Autowired
    MemberRepository memberRepository;

    @Autowired
    SuccessMissionRepository successMissionRepository;

    public List<StampResponseDto> showAll(Long memberId) {
        Member member = (Member) memberRepository.findById(memberId);
        return stampRepository.findByStamp(memberId)
                .stream()
                .map(StampResponseDto::new)
                .collect(Collectors.toList());
    }

    public StampResponseDto showOne(Long stampId) {
        Stamp stamp = stampRepository.findById(stampId).orElseThrow(() -> new IllegalArgumentException("해당 도장이 없습니다. id=" + stampId));
        return new StampResponseDto(stamp);

    }

    public StampResponseDto create(Long memberId, StampRequestDto requesetDto) {
        Member member = (Member) memberRepository.findById(memberId);
        SuccessMission successMission = successMissionRepository.findById(requesetDto.getSuccessMissionId()).orElseThrow(() -> new IllegalArgumentException("해당 미션이 없습니다. id=" + requesetDto.getSuccessMissionId()));

        Stamp stamp = Stamp.builder()
                .member(member)
                .successMission(successMission)
                .build();
        stampRepository.save(stamp);
        return new StampResponseDto(stamp);
    }
}
