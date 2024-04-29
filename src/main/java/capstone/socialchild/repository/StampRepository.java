package capstone.socialchild.repository;

import capstone.socialchild.domain.member.Member;
import capstone.socialchild.domain.mission.SuccessMission;
import capstone.socialchild.domain.stamp.Stamp;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface StampRepository extends JpaRepository<Stamp, Long> {
    @Query(value =
            "SELECT * " +
                    "FROM stamp " +
                    "WHERE member_member_id = :memberId",
            nativeQuery = true)
    List<Stamp> findByStamp(@Param("memberId") Long memberId);


}
