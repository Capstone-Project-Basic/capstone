package capstone.socialchild.service;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.Role;
import capstone.socialchild.domain.mission.Mission;
import capstone.socialchild.dto.mission.MissionListResponseDto;
import capstone.socialchild.dto.mission.MissionRequestDto;
import capstone.socialchild.dto.mission.MissionResponseDto;
import capstone.socialchild.dto.mission.MissionStatusReqDto;
import capstone.socialchild.repository.MemberRepository;
import capstone.socialchild.repository.MissionRepository;
import jakarta.transaction.Transactional;
import lombok.NoArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
@Slf4j
@NoArgsConstructor
public class MissionService {
    @Autowired
    private MissionRepository missionRepository;
    @Autowired
    private MemberRepository memberRepository;

    //미션 생성
    public MissionResponseDto createMission(MissionRequestDto requestDto) {
        if(requestDto.getRole() == Role.TEACHER){
            Mission mission = new Mission(requestDto);
            missionRepository.save(mission);
            return new MissionResponseDto(mission);
        }
        throw new IllegalStateException("미션을 생성할 수 없습니다!");
    }

    public List<MissionListResponseDto> findAllMissions(){
        try{
        List<Mission> missionList = missionRepository.findAll();

        List<MissionListResponseDto> responseDtoList = new ArrayList<>();

        for(Mission mission : missionList) {
            responseDtoList.add(new MissionListResponseDto(mission));
        }
        return responseDtoList;
        } catch (Exception e){
            //에러 발생
        }
        return null;
    }

    public List<MissionListResponseDto> findAllActiveMissions(){
        try{
            List<Mission> missionList = missionRepository.findByActiveStatusTrue();

            List<MissionListResponseDto> responseDtoList = new ArrayList<>();

            for(Mission mission : missionList) {
                responseDtoList.add(new MissionListResponseDto(mission));
            }
            return responseDtoList;
        } catch (Exception e){
            //에러 발생
        }
        return null;
    }

    //미션 찾기 (id로)
    public MissionResponseDto findOneMission(Long id) {
       Mission mission = missionRepository.findById(id).orElseThrow(
               () -> new IllegalArgumentException("조회 실패")
       );
        return new MissionResponseDto(mission);
    }

    public List<MissionListResponseDto> findMissionByTitle(String title) {
        try{
            List<Mission> missionList = missionRepository.findByTitle(title);

            List<MissionListResponseDto> responseDtoList = new ArrayList<>();

            for(Mission mission : missionList) {
                responseDtoList.add(new MissionListResponseDto(mission));
            }
            return responseDtoList;
        } catch (Exception e){
            //에러 발생
        }
        return null;
    }

    @Transactional
    public Long update(Long id, MissionRequestDto requestDto) {
        if(requestDto.getRole() == Role.TEACHER) {
            Mission mission = missionRepository.findById(id).orElseThrow(
                    () -> new IllegalArgumentException("해당 미션이 존재하지 않습니다.")
            );
            mission.update(requestDto);
            return mission.getMissionId();
        }
        throw new IllegalStateException("미션을 수정할 수 없습니다!");
    }

    @Transactional
    public Long updateMissionStatus(Long id, MissionStatusReqDto requestDto) {
        if(requestDto.getRole() == Role.TEACHER) {
            Mission mission = missionRepository.findById(id).orElseThrow(
                    () -> new IllegalArgumentException("해당 미션이 존재하지 않습니다.")
            );
            mission.unactive(requestDto);
            return mission.getMissionId();
        }
        throw new IllegalStateException("미션을 비활성화할 수 없습니다!");
    }

//    @Transactional
//    public Long delete(Long id) {
//        missionRepository.deleteById(id);
//        return id;
//    }
}
