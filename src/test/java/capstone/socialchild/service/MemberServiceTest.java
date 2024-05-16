package capstone.socialchild.service;

import capstone.socialchild.domain.member.Gender;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.member.Role;
import capstone.socialchild.repository.MemberRepository;
import jakarta.persistence.EntityManager;
import org.junit.jupiter.api.BeforeEach;
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
class MemberServiceTest {

    @Autowired
    private MemberService memberService;

    @Autowired
    private MemberRepository memberRepository;

    @Autowired
    private EntityManager em;

    @BeforeEach
    void setUp() {
        em.persist(Member.createMember("user1", "password1", "John Doe", LocalDate.of(2000, 1, 1), Gender.MALE, "123-4567-8901", Role.CHILD));
        em.persist(Member.createMember("user2", "password2", "Jane Doe", LocalDate.of(2000, 2, 2), Gender.FEMALE, "987-6543-2109", Role.CHILD));
        em.flush();
        em.clear();
    }

    @Test
    public void 회원가입_테스트() {
        Member newMember = Member.createMember("newUser", "newPassword", "New User", LocalDate.now(), Gender.MALE, "321-654-9870", Role.TEACHER);
        Long savedId = memberService.join(newMember);
        Member foundMember = memberRepository.findOne(savedId);
        assertNotNull(foundMember);
        assertEquals(newMember.getLoginId(), foundMember.getLoginId());
    }

    @Test
    public void 중복회원_예외() {
        Member duplicateMember = Member.createMember("user1", "password123", "John Duplicate", LocalDate.of(1990, 10, 10), Gender.MALE, "111-222-3333", Role.CHILD);

        IllegalStateException exception = assertThrows(IllegalStateException.class, () -> {
            memberService.join(duplicateMember);
        });

        assertEquals("이미 존재하는 아이디입니다!", exception.getMessage());
    }

    @Test
    public void 회원삭제_테스트() {
        Member member = em.createQuery("SELECT m FROM Member m WHERE m.loginId = :loginId", Member.class)
                .setParameter("loginId", "user1")
                .getSingleResult();
        Long memberId = member.getId();
        assertNotNull(memberRepository.findOne(memberId));

        memberService.deleteMember(memberId);
        assertNull(memberRepository.findOne(memberId));
    }
}
