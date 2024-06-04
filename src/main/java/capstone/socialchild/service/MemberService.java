package capstone.socialchild.service;

import capstone.socialchild.config.SessionManager;
import capstone.socialchild.domain.member.Member;
import capstone.socialchild.dto.member.request.UpdateMember;
import capstone.socialchild.repository.MemberRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Slf4j
@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;
    private final SessionManager sessionManager;

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
     * 회원 조회
     */
    public List<Member> findAllMembers() {
        return memberRepository.findAll();
    }

    public Member findById(Long id) {
        return memberRepository.findOne(id);
    }

    /**
     * 회원 수정
     */
    @Transactional
    public void updateMember(Long memberId, UpdateMember request) {

        Member findMember = (Member) memberRepository.findById(memberId);
        if (findMember == null) {
            throw new EntityNotFoundException("존재하지 않는 회원입니다!");
        }

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

    /**
     * @return null이면 로그인 실패
     */
    public Member login(String loginId, String loginPassword) {
        return memberRepository.findOneByLoginId(loginId)
                .filter(m -> m.getLoginPassword().equals(loginPassword))
                .orElse(null);
    }

    public void addStampCnt(Member member) {
        Long cnt = member.getStampCnt();
        log.info("cnt :   " + cnt);
        member.setStampCnt(cnt + 1);
        log.info("cnt : " + member.getStampCnt());
        memberRepository.update(member);
    }
}

//    /**
//     * 회원 인증
//     */
//    public boolean authenticate(String loginId, String loginPassword) {
//
//        Member member = memberRepository.findOneByLoginId(loginId);
//
//        if (member == null) {
//            log.warn("인증 실패: loginId={}에 해당하는 회원이 없습니다.", loginId);
//            return false;
//        }
//
//        if (member.getLoginPassword().equals(loginPassword)) {
//            log.info("인증 성공: loginId={}", loginId);
//            return true;
//        } else {
//            log.warn("인증 실패: loginId={}의 비밀번호 불일치", loginId);
//            return false;
//        }
//    }

//
//    /**
//     * 현재 로그인한 사용자의 아이디를 세션에서 가져오는 메소드
//     */
//    public String getSessionLoginId(HttpServletRequest request) {
//
//        Member currentMember = (Member) sessionManager.getSession(request);
//
//        if (currentMember == null) {
//            log.error("현재 로그인한 사용자 정보가 세션에 없습니다.");
//            throw new IllegalStateException("사용자가 로그인되어 있지 않습니다.");
//        }
//        return currentMember.getLoginId();
//    }
