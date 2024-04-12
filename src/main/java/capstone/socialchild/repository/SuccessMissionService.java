package capstone.socialchild.repository;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.mission.Mission;
import capstone.socialchild.domain.mission.SuccessMission;
import capstone.socialchild.dto.SuccessMissionDto;
import capstone.socialchild.dto.mission.SuccessMissionDto;
import capstone.socialchild.repository.MemberRepository;
import capstone.socialchild.repository.MissionRepository;
import capstone.socialchild.repository.SucessMissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class SuccessMissionService {

    @Autowired
    private SucessMissionRepository successMissionRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private MissionRepository missionRepository;

    public SuccessMissionDto saveSuccessMission(Long memberId, SuccessMissionDto dto) {
        Member member = (Member) memberRepository.findById(dto.getMemberId());
        Mission mission = missionRepository.findById(dto.getId());

        SuccessMission target = new SuccessMission(mission, member);
        SuccessMission created = successMissionRepository.save(target);
        return SuccessMissionDto.builder()
                .id(created.getId())
                .missionId(created.getMission().getId())
                .memberId(created.getMember().getId())
                .build();
    }


    public List<SuccessMissionDto> showAll(Long memberId) {
        return successMissionRepository.findBySuccessMission(memberId)
                .stream()
                .map(successMission -> SuccessMissionDto.builder()
                        .id(successMission.getId())
                        .missionId(successMission.getMission().getId())
                        .memberId(successMission.getMember().getId())
                        .build())
                .collect(Collectors.toList());
    }
}
