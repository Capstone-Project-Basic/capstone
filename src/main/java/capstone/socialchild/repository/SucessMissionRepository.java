package capstone.socialchild.repository;


import capstone.socialchild.domain.mission.SuccessMission;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface SucessMissionRepository extends JpaRepository<SuccessMission, Long> {

    // 특정 멤버의 모든 성공미션 조회
    @Query(value =
        "SELECT * " +
                "FROM successmsiion " +
                "WHERE member_id = :memberId",
        nativeQuery = true)
    List<SuccessMission> findBySuccessMission(@Param("memberId") Long memberId);
}
