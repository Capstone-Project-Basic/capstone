package capstone.socialchild.controller;

import lombok.Getter;
import lombok.Setter;

import capstone.socialchild.domain.member.Gender;
import capstone.socialchild.domain.member.Role;
import jakarta.validation.constraints.NotEmpty;

import java.time.LocalDate;

@Getter
@Setter
public class MemberForm {

    @NotEmpty(message = "회원 ID는 필수입니다!")
    private String userid;

    private String passwd;

    @NotEmpty(message = "회원 이름은 필수입니다!")
    private String name;
    private LocalDate birth;
    private Gender gender;
    private String phone_no;

    @NotEmpty(message = "신분을 선택해주세요!")
    private Role role;

}