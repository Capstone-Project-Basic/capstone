package capstone.socialchild.repository;

import capstone.socialchild.domain.member.FcmToken;
import jakarta.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface FcmTokenRepository extends JpaRepository<FcmToken,Long> {

        /*@Query("SELECT token FROM Fcm_Token")
        List<String> findAllTokensExcept(String exceptToken);
        //SELECT t.token FROM Fcm_Token t WHERE t.token <> :exceptToken*/
        @Query("SELECT t.token FROM Fcm_Token t WHERE t.token <> :exceptToken")
        List<String> findAllTokensExcept(@Param("exceptToken") String exceptToken);

        @Query("SELECT t.token FROM Fcm_Token t WHERE t.token <> :exceptToken1 AND t.token <> :exceptToken2")
        List<String> findAllTokensExceptTwo(
                @Param("exceptToken1") String exceptToken1,
                @Param("exceptToken2") String exceptToken2);

        @Query("SELECT count(*) FROM Fcm_Token WHERE tokenFlag = true")
        int countFlag();

        @Transactional
        @Modifying
        @Query("UPDATE Fcm_Token SET tokenFlag = false WHERE tokenFlag = true")
        void initFlag();

        @Transactional
        @Modifying
        @Query("UPDATE Fcm_Token SET tokenFlag = true WHERE token = :setTrueToken")
        void setTokenTrue(@Param("setTrueToken") String setTrueToken);

        @Query("SELECT token FROM Fcm_Token WHERE tokenFlag = true")
        List<String> flagTrue();
}
