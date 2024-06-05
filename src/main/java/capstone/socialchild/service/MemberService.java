package capstone.socialchild.service;

import capstone.socialchild.config.SessionManager;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.dto.member.request.UpdateMember;
import capstone.socialchild.repository.MemberRepository;
import jakarta.persistence.EntityNotFoundException;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    /**
     * 회원가입
     */
    @Transactional
    public Long join(Member member) {

        validateDuplicateMember(member);
        memberRepository.save(member);
        return member.getId();
    }

    /**
     * 중복 회원 검증
     */
    private void validateDuplicateMember(Member member) {

        List<Member> findMembers = memberRepository.findByLoginId(member.getLoginId());
        if (!findMembers.isEmpty()) {
            throw new IllegalStateException("이미 존재하는 아이디입니다!");
        }
    }

    /**
     * 로그인
     */
    public Member login(String loginId, String loginPassword) {
        return memberRepository.findOneByLoginId(loginId)
                .filter(m -> m.getLoginPassword().equals(loginPassword))
                .orElse(null);
    }

    /**
     * 회원 조회
     */
    public List<Member> findAllMembers() {
        return memberRepository.findAll();
    }

    public Member findById(Long id) {
        return memberRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("존재하지 않는 회원입니다!"));
    }

    /**
     * 회원 수정
     */
    @Transactional
    public void updateMember(Long memberId, UpdateMember request) {

        Member findMember = memberRepository.findById(memberId)
                .orElseThrow(() -> new EntityNotFoundException("존재하지 않는 회원입니다!"));

        // loginId, Role은 변경 불가로 설정
        findMember.setLoginPassword(request.getLoginPassword());
        findMember.setName(request.getName());
        findMember.setBirth(request.getBirth());
        findMember.setPhone_no(request.getPhone_no());
    }

    /**
     * 회원 삭제
     */
    public void deleteMember(Long id) {
        Member member = memberRepository.findOne(id);
        if (member != null) {
            memberRepository.delete(id);
        } else {
            throw new EntityNotFoundException("존재하지 않는 회원입니다!");
        }
    }

    public void addStampCnt(Member member) {
        Long cnt = member.getStampCnt();
        log.info("cnt :   " + cnt);
        member.setStampCnt(cnt + 1);
        log.info("cnt : " + member.getStampCnt());
        memberRepository.update(member);
    }
}