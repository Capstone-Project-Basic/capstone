package capstone.socialchild.dto.member.request;

import capstone.socialchild.domain.member.Gender;
import capstone.socialchild.domain.member.Role;
import jakarta.validation.constraints.NotEmpty;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

/**
 * 회원가입 request
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
public class SignUp {

    @NotEmpty(message = "회원 ID는 필수입니다!")
    private Long id;                // 회원번호(PK)

    private String loginId;         // 로그인ID
    private String loginPassword;   // 로그인PW

    @NotEmpty(message = "회원 이름은 필수입니다!")
    private String name;            // 이름
    private LocalDate birth;        // 생년월일
    private Gender gender;          // 성별[MALE, FEMALE]
    private String phone_no;        // 전화번호

    @NotEmpty(message = "신분을 선택해주세요!")
    private Role role;              // 역할[CHILD, TEACHER]
}
