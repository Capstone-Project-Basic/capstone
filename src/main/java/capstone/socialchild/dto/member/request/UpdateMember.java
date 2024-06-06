package capstone.socialchild.dto.member.request;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Getter
@NoArgsConstructor
@AllArgsConstructor
public class UpdateMember {

    private String loginPassword;   // 로그인PW
    private String name;            // 이름
    private LocalDate birth;        // 생년월일
    private String phone_no;        // 전화번호
    private String imagePath;       // 이미지 경로
}
