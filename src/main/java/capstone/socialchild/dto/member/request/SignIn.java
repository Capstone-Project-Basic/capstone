package capstone.socialchild.dto.member.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;


/**
 * 로그인 request
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
public class SignIn {

    private String loginId;         // 회원ID
    private String loginPassword;   // 회원PW
}
