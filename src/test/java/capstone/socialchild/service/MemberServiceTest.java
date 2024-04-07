package capstone.socialchild.service;

import capstone.socialchild.controller.MemberForm;
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
    public void 중복회원예외() throws Exception {
        //given
        Member member1 = new Member();
        member1.setName("member");
        member1.setLoginId("user1");


        Member member2 = new Member();
        member2.setName("member123");
        member2.setLoginId("user1");

        //when
        memberService.join(member1);

        //then
        assertThrows(IllegalStateException.class,
                () -> {
                    memberService.join(member2);
                });
    }

    @Test
    // @Rollback(false)
    public void 회원삭제() throws Exception {
        //given
        Member member = createMember("user1", "password1", LocalDate.of(2020, 1, 1), "John Doe", Gender.MALE, "123-4567-8901", Role.CHILD);

        // when
        Long savedId = member.getId();
        memberService.deleteMember(savedId);

        // em.persist(member1);

        // then
        Member deletedMember = em.find(Member.class, savedId);
        assertNull(deletedMember);
    }

//    @Test
//    public void 회원수정() throws Exception {
//        // given
//        Member member = createMember("user1", "password1", LocalDate.of(2020, 1, 1), "John Doe", Gender.MALE, "123-4567-8901", Role.CHILD);
//        Long savedMemberId = member.getId();
//
//        // when
//        MemberForm updateForm = new MemberForm();
//        updateForm.setName("Jane Doe");
//        updateForm.setGender(Gender.FEMALE);
//        updateForm.setPhone_no("987-6543-2109");
//
//        memberService.updateMember(savedMemberId, updateForm);
//        em.flush();
//        em.clear();
//
//        // then
//        Member updatedMember = memberRepository.findOne(savedMemberId);
//        assertEquals("회원 이름이 올바르게 수정되지 않았습니다.", "Jane Doe", updatedMember.getName());
//        assertEquals("회원 성별이 올바르게 수정되지 않았습니다.", Gender.FEMALE, updatedMember.getGender());
//        assertEquals("회원 전화번호가 올바르게 수정되지 않았습니다.", "987-6543-2109", updatedMember.getPhone_no());
//    }


    private Member createMember(String loginId, String loginPassword, LocalDate birth, String name, Gender gender, String phone_no, Role role) throws Exception {

        Member member = new Member();

        member.setLoginId(loginId);
        member.setLoginPassword(loginPassword);
        member.setName(name);
        member.setBirth(birth);
        member.setGender(gender);
        member.setPhone_no(phone_no);
        member.setRole(role);

        em.persist(member);

        return member;
    }
}