package capstone.socialchild.service;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.dto.member.request.UpdateLocation;
import capstone.socialchild.repository.MemberRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequiredArgsConstructor
public class LocationService {

    private final MemberRepository memberRepository;

    /**
     * 위치 수정
     */
    @Transactional
    public boolean updateMemberLocation(Long memberId, UpdateLocation request) {

        Member findMember = memberRepository.findById(memberId)
                .orElseThrow(() -> new EntityNotFoundException("존재하지 않는 회원입니다!"));

        findMember.setLatitude(request.getLatitude());
        findMember.setLongitude(request.getLongitude());
        memberRepository.save(findMember);

        log.info("Updated location for memberId: {}, Latitude: {}, Longitude: {}", memberId, request.getLatitude(), request.getLongitude());
        return true;
    }
}
