package com.planify.service_template.controller;

import com.planify.service_template.model.Example;
import com.planify.service_template.repository.ExampleRepository;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api")
public class ServiceTemplateController {

    private final ExampleRepository repository;

    public ServiceTemplateController(ExampleRepository repository) {
        this.repository = repository;
    }
    @GetMapping("/ping")
    public String ping() {
        return "pong";
    }

    @PostMapping("/examples")
    public Example create(@RequestBody Example example) {
        return repository.save(example);
    }

    @GetMapping("/examples")
    public List<Example> getAll() {
        return repository.findAll();
    }
}
