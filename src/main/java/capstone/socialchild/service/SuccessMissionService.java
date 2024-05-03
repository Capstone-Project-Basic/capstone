package capstone.socialchild.service;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.Role;
import capstone.socialchild.domain.mission.Mission;
import capstone.socialchild.domain.mission.SuccessMission;
import capstone.socialchild.dto.mission.SuccessMissionReqDto;
import capstone.socialchild.dto.mission.SuccessMissionResponseDto;
import capstone.socialchild.repository.MemberRepository;
import capstone.socialchild.repository.MissionRepository;
import capstone.socialchild.repository.SuccessMissionRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class SuccessMissionService {

    @Autowired
    private SuccessMissionRepository successMissionRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private MissionRepository missionRepository;

    public SuccessMissionResponseDto saveSuccessMission(Long memberId, Long missionId, SuccessMissionReqDto dto) {

        Member user = memberRepository.findOne(memberId);
        if (user.getRole() != Role.TEACHER)
            throw new IllegalArgumentException("선생님이 아닙니다.");

        Member member = memberRepository.findOne(dto.getMemberId());
        Mission mission = missionRepository.findById(missionId)
                .orElseThrow(() -> new IllegalArgumentException("해당 미션이 없습니다. id=" + missionId));;

        SuccessMission target = new SuccessMission(mission, member);
        SuccessMission created = successMissionRepository.save(target);

        return new SuccessMissionResponseDto(created);
    }

    public SuccessMissionResponseDto showOne(Long id) {
        SuccessMission entity = successMissionRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("해당 미션이 없습니다. id=" + id));

        return new SuccessMissionResponseDto(entity);
    }

    public List<SuccessMissionResponseDto> showAllOneMember(Long memberId) {
        return successMissionRepository.findBySuccessMission(memberId)
                .stream()
                .map(SuccessMissionResponseDto::new)
                .collect(Collectors.toList());
    }

    public List<SuccessMissionResponseDto> showAll() {
        return successMissionRepository.findByAllSuccessMission()
                .stream()
                .map(SuccessMissionResponseDto::new)
                .collect(Collectors.toList());
    }
}
