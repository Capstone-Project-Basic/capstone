package capstone.socialchild.service;

import capstone.socialchild.domain.member.Gender;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.Role;
import capstone.socialchild.domain.mission.Grade;
import capstone.socialchild.domain.mission.Mission;
import capstone.socialchild.dto.mission.MissionRequestDto;
import capstone.socialchild.repository.MissionRepository;
import org.apache.coyote.Request;
import org.assertj.core.api.Assertions;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(SpringExtension.class)
@SpringBootTest
@Transactional
class MissionServiceTest {

    @Autowired
    MissionService missionService;
    @Autowired
    MissionRepository missionRepository;

    @Test
    void 미션추가_조회() {

        Mission mission = new Mission(new MissionRequestDto("제목","내용", Grade.GOLD, Role.TEACHER));
        missionRepository.save(mission);

        List<Mission> missions = missionRepository.findByTitle("제목");
        Mission mission1 = missions.get(0);
        assertThat(missions.size()).isEqualTo(1);
        assertThat(mission.getMissionId()).isEqualTo(mission.getMissionId());
    }

    @Test
    void 미션추가_오류() {

        Mission mission = new Mission(new MissionRequestDto("제목","내용", Grade.GOLD, Role.CHILD));
        try{
            missionRepository.save(mission);
            List<Mission> missions = missionRepository.findByTitle("제목");
            Mission mission1 = missions.get(0);
            assertThat(missions.size()).isEqualTo(1);
            assertThat(mission.getMissionId()).isEqualTo(mission.getMissionId());
        } catch (IllegalStateException e){
            List<Mission> missions = missionRepository.findAll();
            assertThat(missions.size()).isEqualTo(0);
        }

    }

    @Test
    void 미션수정() {
        Mission mission = new Mission(new MissionRequestDto("제목","내용", Grade.GOLD, Role.TEACHER));
        missionRepository.save(mission);


        mission.update(new MissionRequestDto("수정된 제목", "수정된 내용", Grade.SILVER, Role.TEACHER));
        assertThat(mission.getTitle()).isEqualTo("수정된 제목");
        assertThat(mission.getContent()).isEqualTo("수정된 내용");
        assertThat(mission.getGrade()).isEqualTo(Grade.SILVER);

    }

    @Test
    void 미션삭제() {
        Mission mission = new Mission(new MissionRequestDto("제목","내용", Grade.GOLD,  Role.TEACHER));
        missionRepository.save(mission);
        List<Mission> missions = missionRepository.findAll();
        assertThat(missions.size()).isEqualTo(1);

        missionRepository.delete(mission);
        missions = missionRepository.findAll();
        assertThat(missions.size()).isEqualTo(0);

    }
}