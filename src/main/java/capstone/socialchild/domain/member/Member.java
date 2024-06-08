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

    @Id
    @Column(name = "member_id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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

    @Column(name = "image_path")
    private String imagePath;

    @Column
    private Long stampCnt;

    @Column(nullable = true)
    private Double latitude;

    @Column(nullable = true)
    private Double longitude;

    //==생성 메소드==//
    public static Member createMember(String loginId, String loginPassword,
                                      String name, LocalDate birth, Gender gender,
                                      String phone_no, Role role, String imagePath, Long stampCnt,
                                      Double latitude, Double longitude) {

        Member member = new Member();

        member.setLoginId(loginId);
        member.setLoginPassword(loginPassword);
        member.setName(name);
        member.setBirth(birth);
        member.setGender(gender);
        member.setPhone_no(phone_no);
        member.setRole(role);
        member.setImagePath(imagePath);
        member.setStampCnt(stampCnt);
        member.setLatitude(latitude);
        member.setLongitude(longitude);

        return member;
    }
}