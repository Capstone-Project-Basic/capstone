package capstone.socialchild.repository;

import capstone.socialchild.domain.member.FcmToken;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface FcmTokenRepository extends JpaRepository<FcmToken,Long> {

        /*@Query("SELECT token FROM Fcm_Token")
        List<String> findAllTokensExcept(String exceptToken);
        //SELECT t.token FROM Fcm_Token t WHERE t.token <> :exceptToken*/
        @Query("SELECT t.token FROM Fcm_Token t WHERE t.token <> :exceptToken")
        List<String> findAllTokensExcept(@Param("exceptToken") String exceptToken);
}
