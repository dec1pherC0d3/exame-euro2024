-- Conecte-se à base de dados exameeuro
\c exameeuro;

-- Tabela para armazenar informações dos países
CREATE TABLE pais (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL
);

-- Tabela para armazenar informações das cidades
CREATE TABLE cidade (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    pais_id INT REFERENCES pais(id) ON DELETE CASCADE
);

-- Tabela para armazenar informações dos estádios
CREATE TABLE estadio (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    cidade_id INT REFERENCES cidade(id) ON DELETE CASCADE
);

-- Tabela para armazenar informações das equipas
CREATE TABLE equipa (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL,
    apelido VARCHAR(100) NOT NULL,
    fundacao DATE NOT NULL,
    pais_id INT REFERENCES pais(id) ON DELETE CASCADE
);

-- Tabela para armazenar informações dos jogadores
CREATE TABLE jogador (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    apelido VARCHAR(100) NOT NULL,
    qualidade INT NOT NULL,
    posicao VARCHAR(50) NOT NULL,
    apto_para_jogo BOOLEAN NOT NULL DEFAULT TRUE,
    equipa_id INT REFERENCES equipa(id) ON DELETE CASCADE
);

-- Tabela para armazenar informações dos jogos
CREATE TABLE jogo (
    id SERIAL PRIMARY KEY,
    mandante_id INT REFERENCES equipa(id) ON DELETE CASCADE,
    visitante_id INT REFERENCES equipa(id) ON DELETE CASCADE,
    data DATE NOT NULL,
    estadio_id INT REFERENCES estadio(id) ON DELETE CASCADE,
    placar_mandante INT NOT NULL DEFAULT 0,
    placar_visitante INT NOT NULL DEFAULT 0,
    fase VARCHAR(50) NOT NULL -- Por exemplo: "Qualificação", "Fase de Grupos", "Oitavas de Final", etc.
);

-- Tabela para armazenar informações das substituições
CREATE TABLE substituicao (
    id SERIAL PRIMARY KEY,
    jogo_id INT REFERENCES jogo(id) ON DELETE CASCADE,
    jogador_entrada_id INT REFERENCES jogador(id) ON DELETE CASCADE,
    jogador_saida_id INT REFERENCES jogador(id) ON DELETE CASCADE,
    minuto INT NOT NULL
);

-- Tabela para armazenar informações de golos
CREATE TABLE golo (
    id SERIAL PRIMARY KEY,
    jogo_id INT REFERENCES jogo(id) ON DELETE CASCADE,
    jogador_id INT REFERENCES jogador(id) ON DELETE CASCADE,
    minuto INT NOT NULL,
    tipo VARCHAR(50) NOT NULL -- Por exemplo: "Normal", "Penalti", "Contra"
);

-- Tabela para armazenar informações de cartões
CREATE TABLE cartao (
    id SERIAL PRIMARY KEY,
    jogo_id INT REFERENCES jogo(id) ON DELETE CASCADE,
    jogador_id INT REFERENCES jogador(id) ON DELETE CASCADE,
    data DATE NOT NULL,
    tipo INT NOT NULL CHECK (tipo IN (1, 2))  -- 1 para cartão amarelo, 2 para cartão vermelho
);

-- Tabela para armazenar estatísticas de cada equipa no jogo
CREATE TABLE estatistica_jogo (
    id SERIAL PRIMARY KEY,
    jogo_id INT REFERENCES jogo(id) ON DELETE CASCADE,
    equipa_id INT REFERENCES equipa(id) ON DELETE CASCADE,
    remates INT NOT NULL DEFAULT 0,
    livres INT NOT NULL DEFAULT 0,
    foras_de_jogo INT NOT NULL DEFAULT 0
);

-- Tabela para armazenar estatísticas individuais dos jogadores
CREATE TABLE estatistica_jogador (
    id SERIAL PRIMARY KEY,
    jogador_id INT REFERENCES jogador(id) ON DELETE CASCADE,
    jogo_id INT REFERENCES jogo(id) ON DELETE CASCADE,
    passes INT NOT NULL DEFAULT 0,
    assistencias INT NOT NULL DEFAULT 0,
    remates INT NOT NULL DEFAULT 0,
    minutos_jogados INT NOT NULL DEFAULT 0
);

-- Tabela para armazenar informações dos grupos
CREATE TABLE grupo (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(10) UNIQUE NOT NULL -- Por exemplo: "Grupo A", "Grupo B", etc.
);

-- Tabela para armazenar a constituição dos grupos
CREATE TABLE equipa_grupo (
    id SERIAL PRIMARY KEY,
    grupo_id INT REFERENCES grupo(id) ON DELETE CASCADE,
    equipa_id INT REFERENCES equipa(id) ON DELETE CASCADE
);

-- Tabela para armazenar os resultados dos jogos dos grupos
CREATE TABLE resultado_grupo (
    id SERIAL PRIMARY KEY,
    grupo_id INT REFERENCES grupo(id) ON DELETE CASCADE,
    equipa_id INT REFERENCES equipa(id) ON DELETE CASCADE,
    jogos_jogados INT NOT NULL DEFAULT 0,
    vitorias INT NOT NULL DEFAULT 0,
    empates INT NOT NULL DEFAULT 0,
    derrotas INT NOT NULL DEFAULT 0,
    golos_pro INT NOT NULL DEFAULT 0,
    golos_contra INT NOT NULL DEFAULT 0,
    pontos INT NOT NULL DEFAULT 0
);

-- Tabela para armazenar o calendário dos jogos
CREATE TABLE calendario (
    id SERIAL PRIMARY KEY,
    jogo_id INT REFERENCES jogo(id) ON DELETE CASCADE,
    data DATE NOT NULL
);

-- Tabela para armazenar informações dos melhores marcadores
CREATE TABLE melhor_marcador (
    id SERIAL PRIMARY KEY,
    jogador_id INT REFERENCES jogador(id) ON DELETE CASCADE,
    total_golos INT NOT NULL
);

-- Tabela para armazenar informações de rankings de grupos
CREATE TABLE ranking_grupo (
    id SERIAL PRIMARY KEY,
    grupo_id INT REFERENCES grupo(id) ON DELETE CASCADE,
    equipa_id INT REFERENCES equipa(id) ON DELETE CASCADE,
    posicao INT NOT NULL,
    pontos INT NOT NULL
);





































-- Inserir países
INSERT INTO pais (nome) VALUES ('Alemanha'), ('França'), ('Espanha'), ('Inglaterra'), ('Portugal'), ('Itália'), ('Holanda'), ('Bélgica'), ('Suécia'), ('Dinamarca');


-- Inserir cidades
INSERT INTO cidade (nome, pais_id) VALUES 
('Berlim', (SELECT id FROM pais WHERE nome = 'Alemanha')),
('Paris', (SELECT id FROM pais WHERE nome = 'França')),
('Madrid', (SELECT id FROM pais WHERE nome = 'Espanha')),
('Londres', (SELECT id FROM pais WHERE nome = 'Inglaterra')),
('Lisboa', (SELECT id FROM pais WHERE nome = 'Portugal')),
('Roma', (SELECT id FROM pais WHERE nome = 'Itália')),
('Amsterdã', (SELECT id FROM pais WHERE nome = 'Holanda')),
('Bruxelas', (SELECT id FROM pais WHERE nome = 'Bélgica')),
('Estocolmo', (SELECT id FROM pais WHERE nome = 'Suécia')),
('Copenhague', (SELECT id FROM pais WHERE nome = 'Dinamarca'));


-- Inserir estádios
INSERT INTO estadio (nome, cidade_id) VALUES 
('Estádio Olímpico de Berlim', (SELECT id FROM cidade WHERE nome = 'Berlim')),
('Parc des Princes', (SELECT id FROM cidade WHERE nome = 'Paris')),
('Estádio Santiago Bernabéu', (SELECT id FROM cidade WHERE nome = 'Madrid')),
('Wembley Stadium', (SELECT id FROM cidade WHERE nome = 'Londres')),
('Estádio da Luz', (SELECT id FROM cidade WHERE nome = 'Lisboa')),
('Estádio Olímpico de Roma', (SELECT id FROM cidade WHERE nome = 'Roma')),
('Johan Cruyff Arena', (SELECT id FROM cidade WHERE nome = 'Amsterdã')),
('Estádio Rei Baudouin', (SELECT id FROM cidade WHERE nome = 'Bruxelas')),
('Friends Arena', (SELECT id FROM cidade WHERE nome = 'Estocolmo')),
('Parken Stadium', (SELECT id FROM cidade WHERE nome = 'Copenhague'));


-- Inserir equipas
INSERT INTO equipa (nome, apelido, fundacao, pais_id) VALUES 
('Bayern de Munique', 'Bavarians', '1900-02-27', (SELECT id FROM pais WHERE nome = 'Alemanha')),
('Paris Saint-Germain', 'PSG', '1970-08-12', (SELECT id FROM pais WHERE nome = 'França')),
('Real Madrid', 'Los Blancos', '1902-03-06', (SELECT id FROM pais WHERE nome = 'Espanha')),
('Manchester United', 'Red Devils', '1878-03-05', (SELECT id FROM pais WHERE nome = 'Inglaterra')),
('Sporting CP', 'Leões', '1906-07-01', (SELECT id FROM pais WHERE nome = 'Portugal')),
('Juventus', 'Bianconeri', '1897-11-01', (SELECT id FROM pais WHERE nome = 'Itália')),
('Ajax', 'Amsterdammers', '1900-03-18', (SELECT id FROM pais WHERE nome = 'Holanda')),
('Club Brugge', 'Blauw-Zwart', '1891-11-13', (SELECT id FROM pais WHERE nome = 'Bélgica')),
('AIK', 'Gnaget', '1891-02-15', (SELECT id FROM pais WHERE nome = 'Suécia')),
('FC Copenhagen', 'Løverne', '1992-07-01', (SELECT id FROM pais WHERE nome = 'Dinamarca'));


-- Inserir jogadores
INSERT INTO jogador (nome, apelido, qualidade, posicao, equipa_id) VALUES 
('Manuel Neuer', 'Neuer', 92, 'Goleiro', (SELECT id FROM equipa WHERE nome = 'Bayern de Munique')),
('Kylian Mbappé', 'Mbappé', 94, 'Atacante', (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain')),
('Karim Benzema', 'Benzema', 90, 'Atacante', (SELECT id FROM equipa WHERE nome = 'Real Madrid')),
('Bruno Fernandes', 'Fernandes', 89, 'Meio-Campista', (SELECT id FROM equipa WHERE nome = 'Manchester United')),
('João Mário', 'Mário', 85, 'Meio-Campista', (SELECT id FROM equipa WHERE nome = 'Sporting CP')),
('Paulo Dybala', 'Dybala', 88, 'Atacante', (SELECT id FROM equipa WHERE nome = 'Juventus')),
('Dusan Tadic', 'Tadic', 86, 'Meio-Campista', (SELECT id FROM equipa WHERE nome = 'Ajax')),
('Charles De Ketelaere', 'De Ketelaere', 84, 'Atacante', (SELECT id FROM equipa WHERE nome = 'Club Brugge')),
('Alexander Isak', 'Isak', 87, 'Atacante', (SELECT id FROM equipa WHERE nome = 'AIK')),
('César Azpilicueta', 'Azpilicueta', 83, 'Defensor', (SELECT id FROM equipa WHERE nome = 'FC Copenhagen'));


-- Inserir jogos
INSERT INTO jogo (mandante_id, visitante_id, data, estadio_id, placar_mandante, placar_visitante, fase) VALUES 
((SELECT id FROM equipa WHERE nome = 'Bayern de Munique'), (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain'), '2024-09-01', (SELECT id FROM estadio WHERE nome = 'Estádio Olímpico de Berlim'), 2, 1, 'Qualificação'),
((SELECT id FROM equipa WHERE nome = 'Real Madrid'), (SELECT id FROM equipa WHERE nome = 'Manchester United'), '2024-09-02', (SELECT id FROM estadio WHERE nome = 'Estádio Santiago Bernabéu'), 1, 0, 'Qualificação'),
((SELECT id FROM equipa WHERE nome = 'Sporting CP'), (SELECT id FROM equipa WHERE nome = 'Juventus'), '2024-09-03', (SELECT id FROM estadio WHERE nome = 'Estádio da Luz'), 0, 2, 'Qualificação'),
((SELECT id FROM equipa WHERE nome = 'Ajax'), (SELECT id FROM equipa WHERE nome = 'Club Brugge'), '2024-09-04', (SELECT id FROM estadio WHERE nome = 'Johan Cruyff Arena'), 3, 1, 'Qualificação'),
((SELECT id FROM equipa WHERE nome = 'AIK'), (SELECT id FROM equipa WHERE nome = 'FC Copenhagen'), '2024-09-05', (SELECT id FROM estadio WHERE nome = 'Friends Arena'), 2, 2, 'Qualificação');


-- Inserir substituições
INSERT INTO substituicao (jogo_id, jogador_entrada_id, jogador_saida_id, minuto) VALUES 
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Bayern de Munique') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain')), (SELECT id FROM jogador WHERE nome = 'Manuel Neuer'), (SELECT id FROM jogador WHERE nome = 'Kylian Mbappé'), 75),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Real Madrid') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Manchester United')), (SELECT id FROM jogador WHERE nome = 'Karim Benzema'), (SELECT id FROM jogador WHERE nome = 'Bruno Fernandes'), 60),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Sporting CP') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Juventus')), (SELECT id FROM jogador WHERE nome = 'João Mário'), (SELECT id FROM jogador WHERE nome = 'Paulo Dybala'), 80),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Ajax') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Club Brugge')), (SELECT id FROM jogador WHERE nome = 'Dusan Tadic'), (SELECT id FROM jogador WHERE nome = 'Charles De Ketelaere'), 70),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'AIK') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'FC Copenhagen')), (SELECT id FROM jogador WHERE nome = 'Alexander Isak'), (SELECT id FROM jogador WHERE nome = 'César Azpilicueta'), 85);


-- Inserir gols
INSERT INTO golo (jogo_id, jogador_id, minuto, tipo) VALUES 
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Bayern de Munique') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain')), (SELECT id FROM jogador WHERE nome = 'Kylian Mbappé'), 30, 'Normal'),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Real Madrid') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Manchester United')), (SELECT id FROM jogador WHERE nome = 'Karim Benzema'), 45, 'Normal'),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Sporting CP') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Juventus')), (SELECT id FROM jogador WHERE nome = 'Paulo Dybala'), 50, 'Normal'),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Ajax') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Club Brugge')), (SELECT id FROM jogador WHERE nome = 'Dusan Tadic'), 20, 'Normal'),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'AIK') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'FC Copenhagen')), (SELECT id FROM jogador WHERE nome = 'Alexander Isak'), 15, 'Normal');


-- Inserir cartões
INSERT INTO cartao (jogo_id, jogador_id, data, tipo) VALUES 
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Bayern de Munique') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain')), (SELECT id FROM jogador WHERE nome = 'Kylian Mbappé'), '2024-09-01', 1),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Real Madrid') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Manchester United')), (SELECT id FROM jogador WHERE nome = 'Bruno Fernandes'), '2024-09-02', 2),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Sporting CP') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Juventus')), (SELECT id FROM jogador WHERE nome = 'João Mário'), '2024-09-03', 1),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Ajax') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Club Brugge')), (SELECT id FROM jogador WHERE nome = 'Dusan Tadic'), '2024-09-04', 2),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'AIK') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'FC Copenhagen')), (SELECT id FROM jogador WHERE nome = 'César Azpilicueta'), '2024-09-05', 1);



-- Inserir estatísticas de jogo
INSERT INTO estatistica_jogo (jogo_id, equipa_id, remates, livres, foras_de_jogo) VALUES 
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Bayern de Munique') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain')), (SELECT id FROM equipa WHERE nome = 'Bayern de Munique'), 10, 5, 2),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Real Madrid') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Manchester United')), (SELECT id FROM equipa WHERE nome = 'Real Madrid'), 8, 3, 1),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Sporting CP') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Juventus')), (SELECT id FROM equipa WHERE nome = 'Sporting CP'), 6, 2, 0),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Ajax') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Club Brugge')), (SELECT id FROM equipa WHERE nome = 'Ajax'), 12, 4, 3),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'AIK') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'FC Copenhagen')), (SELECT id FROM equipa WHERE nome = 'AIK'), 9, 6, 2);


-- Inserir estatísticas individuais dos jogadores
INSERT INTO estatistica_jogador (jogador_id, jogo_id, passes, assistencias, remates, minutos_jogados) VALUES 
((SELECT id FROM jogador WHERE nome = 'Manuel Neuer'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Bayern de Munique') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain')), 0, 0, 1, 90),
((SELECT id FROM jogador WHERE nome = 'Kylian Mbappé'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Bayern de Munique') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain')), 1, 0, 1, 90),
((SELECT id FROM jogador WHERE nome = 'Karim Benzema'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Real Madrid') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Manchester United')), 2, 1, 3, 85),
((SELECT id FROM jogador WHERE nome = 'Bruno Fernandes'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Real Madrid') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Manchester United')), 3, 1, 2, 85),
((SELECT id FROM jogador WHERE nome = 'João Mário'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Sporting CP') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Juventus')), 1, 0, 0, 75),
((SELECT id FROM jogador WHERE nome = 'Paulo Dybala'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Sporting CP') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Juventus')), 2, 1, 2, 75),
((SELECT id FROM jogador WHERE nome = 'Dusan Tadic'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Ajax') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Club Brugge')), 4, 2, 2, 90),
((SELECT id FROM jogador WHERE nome = 'Charles De Ketelaere'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Ajax') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Club Brugge')), 1, 0, 1, 90),
((SELECT id FROM jogador WHERE nome = 'Alexander Isak'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'AIK') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'FC Copenhagen')), 2, 1, 1, 90),
((SELECT id FROM jogador WHERE nome = 'César Azpilicueta'), (SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'AIK') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'FC Copenhagen')), 0, 0, 0, 90);


-- Inserir grupos
INSERT INTO grupo (nome) VALUES 
('Grupo A'), ('Grupo B'), ('Grupo C'), ('Grupo D');


-- Inserir constituição dos grupos
INSERT INTO equipa_grupo (grupo_id, equipa_id) VALUES 
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Bayern de Munique')),
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain')),
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Real Madrid')),
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Manchester United')),

((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Sporting CP')),
((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Juventus')),
((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Ajax')),
((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Club Brugge')),

((SELECT id FROM grupo WHERE nome = 'Grupo C'), (SELECT id FROM equipa WHERE nome = 'AIK')),
((SELECT id FROM grupo WHERE nome = 'Grupo C'), (SELECT id FROM equipa WHERE nome = 'FC Copenhagen')),
((SELECT id FROM grupo WHERE nome = 'Grupo C'), (SELECT id FROM equipa WHERE nome = 'Bayern de Munique')),
((SELECT id FROM grupo WHERE nome = 'Grupo C'), (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain'));



-- Inserir resultados dos grupos
INSERT INTO resultado_grupo (grupo_id, equipa_id, jogos_jogados, vitorias, empates, derrotas, golos_pro, golos_contra, pontos) VALUES 
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Bayern de Munique'), 2, 1, 1, 0, 3, 2, 4),
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain'), 2, 1, 1, 0, 2, 1, 4),
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Real Madrid'), 2, 1, 0, 1, 2, 3, 3),
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Manchester United'), 2, 0, 1, 1, 1, 3, 1),

((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Sporting CP'), 2, 1, 0, 1, 1, 2, 3),
((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Juventus'), 2, 1, 1, 0, 3, 1, 4),
((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Ajax'), 2, 0, 1, 1, 1, 2, 1),
((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Club Brugge'), 2, 0, 1, 1, 2, 3, 1);



-- Inserir calendário dos jogos
INSERT INTO calendario (jogo_id, data) VALUES 
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Bayern de Munique') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain')), '2024-09-01'),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Real Madrid') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Manchester United')), '2024-09-02'),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Sporting CP') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Juventus')), '2024-09-03'),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'Ajax') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'Club Brugge')), '2024-09-04'),
((SELECT id FROM jogo WHERE mandante_id = (SELECT id FROM equipa WHERE nome = 'AIK') AND visitante_id = (SELECT id FROM equipa WHERE nome = 'FC Copenhagen')), '2024-09-05');


-- Inserir melhores marcadores
INSERT INTO melhor_marcador (jogador_id, total_golos) VALUES 
((SELECT id FROM jogador WHERE nome = 'Kylian Mbappé'), 1),
((SELECT id FROM jogador WHERE nome = 'Karim Benzema'), 1),
((SELECT id FROM jogador WHERE nome = 'Paulo Dybala'), 1),
((SELECT id FROM jogador WHERE nome = 'Dusan Tadic'), 1),
((SELECT id FROM jogador WHERE nome = 'Alexander Isak'), 1);


-- Inserir rankings dos grupos
INSERT INTO ranking_grupo (grupo_id, equipa_id, posicao, pontos) VALUES 
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Bayern de Munique'), 1, 4),
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Paris Saint-Germain'), 2, 4),
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Real Madrid'), 3, 3),
((SELECT id FROM grupo WHERE nome = 'Grupo A'), (SELECT id FROM equipa WHERE nome = 'Manchester United'), 4, 1),

((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Juventus'), 1, 4),
((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Sporting CP'), 2, 3),
((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Club Brugge'), 3, 1),
((SELECT id FROM grupo WHERE nome = 'Grupo B'), (SELECT id FROM equipa WHERE nome = 'Ajax'), 4, 1);


SELECT j.nome AS jogador, j.apelido, e.nome AS equipa
FROM jogador j
JOIN equipa e ON j.equipa_id = e.id;


SELECT e.nome AS equipa, ej.remates, ej.livres, ej.foras_de_jogo
FROM estatistica_jogo ej
JOIN equipa e ON ej.equipa_id = e.id;


SELECT j.nome, j.apelido, mm.total_golos
FROM melhor_marcador mm
JOIN jogador j ON mm.jogador_id = j.id
ORDER BY mm.total_golos DESC;


SELECT e1.nome AS mandante, e2.nome AS visitante, j.data, st.nome AS estadio
FROM jogo j
JOIN equipa e1 ON j.mandante_id = e1.id
JOIN equipa e2 ON j.visitante_id = e2.id
JOIN estadio st ON j.estadio_id = st.id
ORDER BY j.data;


SELECT g.nome AS grupo, e.nome AS equipa, rg.pontos, rg.vitorias, rg.empates, rg.derrotas, rg.golos_pro, rg.golos_contra
FROM resultado_grupo rg
JOIN grupo g ON rg.grupo_id = g.id
JOIN equipa e ON rg.equipa_id = e.id
ORDER BY g.nome, rg.pontos DESC;


SELECT e1.nome AS mandante, e2.nome AS visitante, j.data, j.placar_mandante, j.placar_visitante
FROM jogo j
JOIN equipa e1 ON j.mandante_id = e1.id
JOIN equipa e2 ON j.visitante_id = e2.id
WHERE j.id = 1;  -- Substitua 1 pelo id do jogo desejado









































SELECT * FROM jogador WHERE id = 1;  -- Substitua 1 pelo ID do jogador


SELECT * FROM equipa WHERE id = 1;  -- Substitua 1 pelo ID da equipa



SELECT j.nome, j.apelido, mm.total_golos
FROM melhor_marcador mm
JOIN jogador j ON mm.jogador_id = j.id


ORDER BY mm.total_golos DESC;



SELECT e.nome, rg.pontos, rg.vitorias, rg.empates, rg.derrotas, rg.golos_pro, rg.golos_contra
FROM resultado_grupo rg
JOIN equipa e ON rg.equipa_id = e.id
WHERE rg.grupo_id = 1  -- Substitua 1 pelo ID do grupo
ORDER BY rg.pontos DESC, rg.golos_pro - rg.golos_contra DESC;


SELECT j.data, m.nome AS mandante, v.nome AS visitante, j.placar_mandante, j.placar_visitante, e.nome AS estadio
FROM jogo j
JOIN equipa m ON j.mandante_id = m.id
JOIN equipa v ON j.visitante_id = v.id
JOIN estadio e ON j.estadio_id = e.id
WHERE j.id = 1;  -- Substitua 1 pelo ID do jogo



SELECT e.nome, ej.remates, ej.livres, ej.foras_de_jogo
FROM estatistica_jogo ej
JOIN equipa e ON ej.equipa_id = e.id
WHERE ej.jogo_id = 1;  -- Substitua 1 pelo ID do jogo



SELECT j.nome, j.apelido, ej.passes, ej.assistencias, ej.remates, ej.minutos_jogados
FROM estatistica_jogador ej
JOIN jogador j ON ej.jogador_id = j.id
WHERE ej.jogo_id = 1;  -- Substitua 1 pelo ID do jogo


SELECT j.data, m.nome AS mandante, v.nome AS visitante, e.nome AS estadio
FROM calendario c
JOIN jogo j ON c.jogo_id = j.id
JOIN equipa m ON j.mandante_id = m.id
JOIN equipa v ON j.visitante_id = v.id
JOIN estadio e ON j.estadio_id = e.id
ORDER BY j.data;

