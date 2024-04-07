package capstone.socialchild.service;

import capstone.socialchild.domain.member.Gender;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.Role;
import capstone.socialchild.repository.MemberRepository;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.annotation.Rollback;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;

@ExtendWith(SpringExtension.class)
@SpringBootTest
@Transactional
class MemberServiceTest {

    @Autowired MemberService memberService;
    @Autowired MemberRepository memberRepository;
    @Autowired EntityManager em;

    @Test
    @Rollback(false)
    public void 회원가입() throws Exception {
        //given
        Member member1 = new Member();
        member1.setLoginId("user1");
        member1.setLoginPassword("password1");
        member1.setName("John Doe");
        member1.setBirth(LocalDate.of(2020, 5, 15));
        member1.setGender(Gender.MALE);
        member1.setPhone_no("123-4567-8901");
        member1.setRole(Role.CHILD);

        // given2
        Member member2 = new Member();
        member2.setLoginId("user2");
        member2.setLoginPassword("password2");
        member2.setName("Jane Smith");
        member2.setBirth(LocalDate.of(2021, 10, 25));
        member2.setGender(Gender.FEMALE);
        member2.setPhone_no("234-5678-9012");
        member2.setRole(Role.CHILD);

        em.persist(member1);
        em.persist(member2);

        //when
        Long savedId = member1.getId();

        //then
        em.flush();
        assertEquals(member1, memberRepository.findOne(savedId));

    }

    @Test
    // @Rollback(false)
    public void 회원삭제() throws Exception {
        //given
        Member member1 = new Member();
        member1.setLoginId("user1");
        member1.setLoginPassword("password1");
        member1.setName("John Doe");
        member1.setBirth(LocalDate.of(2020, 5, 15));
        member1.setGender(Gender.MALE);
        member1.setPhone_no("123-4567-8901");
        member1.setRole(Role.CHILD);
        em.persist(member1);

        // when
        Long savedId = member1.getId();
        memberService.deleteMember(savedId);

        // em.persist(member1);

        // then
        Member deletedMember = em.find(Member.class, savedId);
        assertNull(deletedMember);


    }
}