package capstone.socialchild.domain.member;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDate;

import static jakarta.persistence.EnumType.STRING;

@Entity
@Table(name = "members")
@Getter @Setter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Member {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "member_id")
    private Long id;

    @Column
    private String loginId;

    private String loginPassword;

    private String name;
    private LocalDate birth;

    @Enumerated(value = STRING)
    private Gender gender;
    private String phone_no;

    @Enumerated(value = STRING)
    private Role role;

    //==생성 메소드==//
    public static Member createMember(String loginId, String loginPassword, String name, LocalDate birth, Gender gender, String phone_no, Role role) {

        Member member = new Member();

        member.setLoginId(loginId);
        member.setLoginPassword(loginPassword);
        member.setName(name);
        member.setBirth(birth);
        member.setGender(gender);
        member.setPhone_no(phone_no);
        member.setRole(role);

        return member;
    }
}
