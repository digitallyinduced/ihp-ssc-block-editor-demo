

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;


SET SESSION AUTHORIZATION DEFAULT;

ALTER TABLE public.posts DISABLE TRIGGER ALL;

INSERT INTO public.posts (id, title, created_at) VALUES ('603dc027-6305-4055-bef3-aedaa0fdf3f7', 'est', '2021-06-12 11:54:20.327718+02');


ALTER TABLE public.posts ENABLE TRIGGER ALL;


ALTER TABLE public.blocks DISABLE TRIGGER ALL;

INSERT INTO public.blocks (id, block_type, post_id, order_position, paragraph_text, headline_text, raw_html, image_src) VALUES ('ca4b5786-d88e-4ecd-b96a-e4030a7ff480', 'headline', '603dc027-6305-4055-bef3-aedaa0fdf3f7', 6, NULL, 'Some sub headline', NULL, NULL);
INSERT INTO public.blocks (id, block_type, post_id, order_position, paragraph_text, headline_text, raw_html, image_src) VALUES ('9600231b-4277-4ac1-b4fa-babd4fb0f679', 'paragraph', '603dc027-6305-4055-bef3-aedaa0fdf3f7', 7, 'duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', NULL, NULL, NULL);
INSERT INTO public.blocks (id, block_type, post_id, order_position, paragraph_text, headline_text, raw_html, image_src) VALUES ('41a46e6f-edf7-4b28-9f5f-120263ea2f94', 'paragraph', '603dc027-6305-4055-bef3-aedaa0fdf3f7', 8, 'duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', NULL, NULL, NULL);
INSERT INTO public.blocks (id, block_type, post_id, order_position, paragraph_text, headline_text, raw_html, image_src) VALUES ('f211bdcd-a618-4597-a544-0d10d938c1ae', 'headline', '603dc027-6305-4055-bef3-aedaa0fdf3f7', 1, NULL, 'This is a new post', NULL, NULL);
INSERT INTO public.blocks (id, block_type, post_id, order_position, paragraph_text, headline_text, raw_html, image_src) VALUES ('afdda3b8-9136-484e-98d5-3a3839d04eea', 'raw_html', '603dc027-6305-4055-bef3-aedaa0fdf3f7', 4, NULL, NULL, '<p>hello</p>', NULL);
INSERT INTO public.blocks (id, block_type, post_id, order_position, paragraph_text, headline_text, raw_html, image_src) VALUES ('740eb11c-76dd-4cb5-aa99-719f3bf44383', 'paragraph', '603dc027-6305-4055-bef3-aedaa0fdf3f7', 5, 'eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elit', NULL, NULL, NULL);
INSERT INTO public.blocks (id, block_type, post_id, order_position, paragraph_text, headline_text, raw_html, image_src) VALUES ('4f162305-e430-4409-887d-11f8ae9cccb9', 'image', '603dc027-6305-4055-bef3-aedaa0fdf3f7', 2, NULL, NULL, NULL, 'https://images.unsplash.com/photo-1623463199299-239e6c5447da?ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwxOHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60');
INSERT INTO public.blocks (id, block_type, post_id, order_position, paragraph_text, headline_text, raw_html, image_src) VALUES ('653828b3-76ac-4827-be32-46205ebfee54', 'paragraph', '603dc027-6305-4055-bef3-aedaa0fdf3f7', 3, 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.', NULL, NULL, NULL);


ALTER TABLE public.blocks ENABLE TRIGGER ALL;


