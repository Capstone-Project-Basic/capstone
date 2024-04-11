package capstone.socialchild.controller;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.dto.member.request.SignUp;
import capstone.socialchild.dto.member.request.UpdateMember;
import capstone.socialchild.dto.member.response.DetailMember;
import capstone.socialchild.repository.MemberRepository;
import capstone.socialchild.service.MemberService;
import lombok.RequiredArgsConstructor;
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

    /**
     * 회원 가입
     */
    @PostMapping("/new")
    public ResponseEntity<Member> createMember(@RequestBody SignUp request) {

        Member member = Member.createMember(request.getLoginId(), request.getLoginPassword(), request.getName(), request.getBirth(), request.getGender(), request.getPhone_no(), request.getRole());
        Long memberId = memberService.join(member);

        return ResponseEntity
                .created(URI.create("/new/" + memberId))
                .build();
    }

    /**
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
    @PatchMapping("/{memberId}")
    public ResponseEntity<Object> updateMember(@PathVariable Long memberId, @RequestBody UpdateMember request) {

        memberService.updateMember(memberId, request);
        Member findMember = memberService.findById(memberId);

        return ResponseEntity.noContent().build();
    }

    /**
     * 회원 삭제
     */
    @DeleteMapping("/{memberId}")
    public ResponseEntity<Object> deleteMember(@PathVariable Long memberId) {

        memberService.deleteMember(memberId);
        return ResponseEntity.noContent().build();
    }
}
