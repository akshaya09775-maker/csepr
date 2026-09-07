package app.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/")
public class Index {

    @GetMapping()
    Map<Object, Object> test() {
        Map<Object, Object> res = new HashMap<>();

        res.put("msg", "Testing spring-boot 🍃 ");
        res.put("status", "server is running sucess ✅");
        res.put("database", "mysql 🐬");
        res.put("url", "https://www.tldraw.com/p/5UQ6h-f75_kWPdctdgFKT?d=v-988.205.2010.1080.Rn3GizGhjQcLThAKFLCiX");
        // res.put("vedio", "https://wormhole.app/qlMK0E#ZcKTVvDaIotqz6qdjTVkMg");
        return res;
    }

}
