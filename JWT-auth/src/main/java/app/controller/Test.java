package app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class Test {

    @GetMapping("/test")
    public static String test() {
        return "Test";
    }

    @GetMapping("/index")
    public String t() {
        return "index";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/main")
    public String main() {
        return "main";
    }
}
