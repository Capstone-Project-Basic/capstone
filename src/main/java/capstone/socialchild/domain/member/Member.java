package capstone.socialchild.domain.member;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.LocalDate;

import static jakarta.persistence.EnumType.STRING;

@Entity
@Getter @Setter
public class Member {

    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long member_id;

    @Column
    private String userid;

    @Column
    private String passwd;

    private String name;
    private LocalDate birth;

    @Enumerated(value = STRING)
    private Gender gender;
    private String phone_no;

    @Enumerated(value = STRING)
    private Role role;

}
