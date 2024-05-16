package capstone.socialchild.controller;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.dto.member.request.SignIn;
import capstone.socialchild.dto.member.request.SignUp;
import capstone.socialchild.dto.member.request.UpdateMember;
import capstone.socialchild.dto.member.response.DetailMember;
import capstone.socialchild.repository.MemberRepository;
import capstone.socialchild.service.MemberService;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;

@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
@CrossOrigin(origins = {"https://localhost:8080"}) // Flutter 포트번호에 따라 바뀔 수 있음
public class MemberController {

    private final MemberService memberService;
    private final MemberRepository memberRepository;

    /*
     * 회원 상세 조회
     */
    @GetMapping("/{memberId}")
    public DetailMember findDetailMember(@PathVariable Long memberId) {

        Member findMember = memberService.findById(memberId);

        return DetailMember.of(findMember);
    }

    /**
     * 회원 전체 조회
     */
    @GetMapping
    public List<DetailMember> findAllDetailMembers() {

        List<Member> members = memberRepository.findAll();

        return members.stream()
                .map(DetailMember::of)
                .toList();
    }

    /**
     * 회원 검색(이름)
     */
    @GetMapping("/search")
    public List<DetailMember> searchMembers(@RequestParam String name) {

        return memberRepository.findByName(name)
                .stream()
                .map(DetailMember::of)
                .toList();
    }

    /**
     * 회원 수정
     */
    @Transactional
    public void updateMember(Long memberId, UpdateMember request) {

        Member findMember = memberRepository.findOne(memberId);
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
}