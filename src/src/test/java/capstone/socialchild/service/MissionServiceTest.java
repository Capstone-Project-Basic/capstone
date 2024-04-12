package capstone.socialchild.service;

import capstone.socialchild.domain.Mission.Grade;
import capstone.socialchild.domain.Mission.Mission;
import capstone.socialchild.domain.member.Gender;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.Role;
import capstone.socialchild.dto.MissionRequestDto;
import capstone.socialchild.repository.MissionRepository;
import org.apache.coyote.Request;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

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
    void 미션추가() {
        Member member1 = new Member();
        member1.setLoginId("user1");
        member1.setLoginPassword("password1");
        member1.setName("John Doe");
        member1.setBirth(LocalDate.of(2020, 5, 15));
        member1.setGender(Gender.MALE);
        member1.setPhone_no("123-4567-8901");
        member1.setRole(Role.TEACHER);
        Mission mission = new Mission(new MissionRequestDto("제목","내용", Grade.GOLD,member1));
        missionRepository.save(mission);

    }
}