-- Create Schema
CREATE SCHEMA meta;

-- Create Extension
CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;

-- Create Tables
CREATE TABLE meta.embeddings (
    id BIGINT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    content TEXT NOT NULL,
    embedding public.vector(384) NOT NULL
);

ALTER TABLE meta.embeddings ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME meta.embeddings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE meta.migrations (
    version TEXT NOT NULL,
    name TEXT,
    applied_at TIMESTAMPTZ DEFAULT now() NOT NULL
);

CREATE TABLE public.class (
    id BIGINT NOT NULL,
    name TEXT NOT NULL,
    teacher_id BIGINT,
    school_id BIGINT
);

ALTER TABLE public.class ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.class_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.enrollment (
    id BIGINT NOT NULL,
    student_id BIGINT,
    class_id BIGINT
);

ALTER TABLE public.enrollment ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.enrollment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.school (
    id BIGINT NOT NULL,
    name TEXT NOT NULL,
    address TEXT,
    established_year INTEGER
);

ALTER TABLE public.school ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.school_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.student (
    id BIGINT NOT NULL,
    name TEXT NOT NULL,
    age INTEGER,
    grade TEXT,
    school_id BIGINT
);

ALTER TABLE public.student ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.student_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.teacher (
    id BIGINT NOT NULL,
    name TEXT NOT NULL,
    subject TEXT,
    school_id BIGINT
);

ALTER TABLE public.teacher ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.teacher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

-- Insert Sample Data
INSERT INTO meta.migrations VALUES ('202407160001', 'embeddings', '2024-12-18 12:25:00.13+00');

-- Primary Key Constraints
ALTER TABLE ONLY meta.embeddings ADD CONSTRAINT embeddings_pkey PRIMARY KEY (id);
ALTER TABLE ONLY meta.migrations ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);
ALTER TABLE ONLY public.class ADD CONSTRAINT class_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.enrollment ADD CONSTRAINT enrollment_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.school ADD CONSTRAINT school_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.student ADD CONSTRAINT student_pkey PRIMARY KEY (id);
ALTER TABLE ONLY public.teacher ADD CONSTRAINT teacher_pkey PRIMARY KEY (id);

-- Foreign Key Constraints
ALTER TABLE ONLY public.class ADD CONSTRAINT class_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);
ALTER TABLE ONLY public.class ADD CONSTRAINT class_teacher_id_fkey FOREIGN KEY (teacher_id) REFERENCES public.teacher(id);
ALTER TABLE ONLY public.enrollment ADD CONSTRAINT enrollment_class_id_fkey FOREIGN KEY (class_id) REFERENCES public.class(id);
ALTER TABLE ONLY public.enrollment ADD CONSTRAINT enrollment_student_id_fkey FOREIGN KEY (student_id) REFERENCES public.student(id);
ALTER TABLE ONLY public.student ADD CONSTRAINT student_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);
ALTER TABLE ONLY public.teacher ADD CONSTRAINT teacher_school_id_fkey FOREIGN KEY (school_id) REFERENCES public.school(id);
