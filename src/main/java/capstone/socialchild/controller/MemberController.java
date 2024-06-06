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
import java.util.Optional;

@RestController
@RequestMapping("/members")
@RequiredArgsConstructor
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
    @PatchMapping("/{memberId}/image")
    public ResponseEntity<Member> updateMember(@PathVariable Long memberId, @RequestBody UpdateMember request) {

        Optional<Member> findMember = memberRepository.findById(memberId);
        findMember.orElseThrow(() -> new EntityNotFoundException("존재하지 않는 회원입니다!"));


        // loginId, Role은 변경 불가로 설정
        memberService.updateMember(memberId, request);

        return ResponseEntity.ok(findMember.get());
    }

    /**
     * 회원 삭제
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<String> deleteMember(@PathVariable Long id) {
        Optional<Member> member = memberRepository.findById(id);
        if (member.isPresent()) {
            memberRepository.delete(id);
            return ResponseEntity.ok("회원 삭제가 완료되었습니다.");
        } else {
            throw new EntityNotFoundException("존재하지 않는 회원입니다!");
        }
    }

}