package com.planify.service_template.event;

import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Component;

@Component
public class KafkaConsumer {

    @KafkaListener(topics = "template-topic")
    public void consume(String message) {
        System.out.println("Received: " + message);
    }
}
