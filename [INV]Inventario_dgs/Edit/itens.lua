itens = {
    ["Armamentos"] = {
        ["ParaFal"] = {
            acumulavel = false,
            peso = 4.5,
            id = 31,
            calibre = "762",
            tipo = "Fuzil"
        },
        ["AK47"] = {
            acumulavel = false,
            peso = 4.3,
            id = 30,
            calibre = "762",
            tipo = "Fuzil"
        },
        ["RT82"] = {
            acumulavel = false,
            peso = 1.06,
            id = 24,
            calibre = "38",
            tipo = "Secundaria"
        },
        ["TH40"] = {
            acumulavel = false,
            peso = 0.78,
            id = 23,
            calibre = "40",
            tipo = "Secundaria"
        },
        ["MT40"] = {
            acumulavel = false,
            peso = 2.7,
            id = 29,
            calibre = "40",
            tipo = "Submetralhadora"
        }
    },
    ["Munições"] = {
        ["762"] = {
            acumulavel = true,
            quantidade = 30,
            peso = 0.024
        },
        ["40"] = {
            acumulavel = true,
            quantidade = 15,
            peso = 0.01166
        },
        ["38"] = {
            acumulavel = true,
            quantidade = 10,
            peso = 0.01024
        }
    },
    ["Alimentos"] = {
        ["Biscoito"] = {
            acumulavel = true,
            quantidade = 4,
            peso = 0.17,
            alteracao = "Fome",
            valor = 5
        },
        ["Garrafa_D'Água"] = {
            acumulavel = false,
            peso = 0.5,
            alteracao = "Sede",
            valor = 20
        }
    },
    ["Mídias"] = {
        ["Pendrive"] = {
            acumulavel = false,
            peso = 0.008,
            espaco = 8.192
        }
    }
}
PesoMaximo = 40