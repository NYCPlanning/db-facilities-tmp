def test_add_computed_field_func():
    from dataflows import add_computed_field,Flow

    data = [
        dict(x=i) for i in range(3)
    ]

    f = Flow(
        data,
        add_computed_field([
            dict(target=dict(name='sq', type='integer'),
                 operation=lambda row: row['x'] ** 2),
            dict(target='f', operation='format', with_='{x} - {x}')
        ])
    )
    results, *_ = f.results()
    results = list(results[0])

    assert results == [
        dict(x=0, sq=0, f='0 - 0'),
        dict(x=1, sq=1, f='1 - 1'),
        dict(x=2, sq=4, f='2 - 2'),
    ]
