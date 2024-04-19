package capstone.socialchild.service;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.mission.Mission;
import capstone.socialchild.domain.mission.SuccessMission;
import capstone.socialchild.dto.mission.SuccessMissionDto;
import capstone.socialchild.dto.mission.SuccessMissionResponseDto;
import capstone.socialchild.repository.MemberRepository;
import capstone.socialchild.repository.MissionRepository;
import capstone.socialchild.repository.SuccessMissionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;

@Service
public class SuccessMissionService {

    @Autowired
    private SuccessMissionRepository successMissionRepository;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private MissionRepository missionRepository;

    public SuccessMissionDto saveSuccessMission(Long memberId, Long missionId, SuccessMissionDto dto) {
        Member member = (Member) memberRepository.findById(memberId);
        Mission mission = missionRepository.findById(missionId)
                .orElseThrow(() -> new RuntimeException("Mission not found"));

        SuccessMission target = new SuccessMission(mission, member);
        SuccessMission created = successMissionRepository.save(target);
        return SuccessMissionDto.builder()
                .id(created.getId())
                .missionId(created.getMission().getMissionId())
                .memberId(created.getMember().getId())
                .build();
    }

    public SuccessMissionResponseDto showOne(Long id) {
        SuccessMission entity = successMissionRepository.findById(id).orElseThrow(() -> new IllegalArgumentException("해당 미션이 없습니다. id=" + id));

        return new SuccessMissionResponseDto(entity);
    }


    public List<SuccessMissionDto> showAll(Long memberId) {
        return successMissionRepository.findBySuccessMission(memberId)
                .stream()
                .map(successMission -> SuccessMissionDto.builder()
                        .id(successMission.getId())
                        .missionId(successMission.getMission().getMissionId())
                        .memberId(successMission.getMember().getId())
                        .build())
                .collect(Collectors.toList());
    }
}
